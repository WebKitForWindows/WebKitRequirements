#--------------------------------------------------------------------------
# Constants
#--------------------------------------------------------------------------

# List of triplets to build
triplets = [
  'x64-windows-webkit',
  'x86-windows-webkit',
]

# Current Windows version to use
windows_version = 1809

#--------------------------------------------------------------------------
# Build config
#--------------------------------------------------------------------------

def build_config(triplet):
  suffix = '64' if triplet.startswith('x64') else '32'

  return {
    'triplet': triplet,
    'build-image': 'webkitdev/msbuild',
    'ports': [
      # This should be kept in sync with WindowsRequirements.json
      'zlib',
      'brotli',
      'libressl',
      'nghttp2',
      'curl[ssl,ipv6]',
      'icu',
      'libxml2[xslt]',
      'libxslt',
      'libpng',
      'libjpeg-turbo',
      'libwebp',
      'openjpeg',
      'sqlite3',
      'pixman',
      'cairo',
      'libpsl',
      # Additional ports
      'pthreads',
      'cflite',
    ],
    'distribution': 'WebKitRequirementsWin' + suffix + '.zip',
    'volumes': [],
    'environment': {},
  }

#--------------------------------------------------------------------------
# Steps
#--------------------------------------------------------------------------

def build_vcpkg(config):
  return {
    'name': 'vcpkg',
    'image': config['build-image'],
    'pull': 'always',
    'commands': ['./Install-Vcpkg.ps1 -VcpkgPath C:/vcpkg'],
  }

def download_vcpkg_tools(config):
  return {
    'name': 'download-vcpkg-tools',
    'image': config['build-image'],
    'commands': ['./Download-VcpkgTools.ps1 -ToolsPath ./scripts/vcpkgTools.xml'],
  }

def build_port(port, config):
  triplet = config['triplet']
  build_image = config['build-image']
  # Don't include any feature defines (e.g [foo])
  port_name = port.split('[')[0]

  return {
    'name': port_name,
    'image': build_image,
    'commands': ['./vcpkg.exe install {} --triplet {}'.format(port, triplet)],
    'volumes': config['volumes'],
    'environment': config['environment'],
    'steps': _build_output(port_name, triplet, build_image),
  }

def _build_output(port, triplet, build_image, step_name=''):
  # These steps should always run to capture config and compilation errors
  when_clause = {'status': ['success', 'failure']}
  if not step_name:
    step_name = port

  return [
    {
      'name': step_name + '-config',
      'image': build_image,
      'commands': ['Get-Content ./buildtrees/{}/config-{}-out.log'.format(port, triplet)],
      'when': when_clause,
    },
    {
      'name': step_name + '-debug-build',
      'image': build_image,
      'commands': ['Get-Content ./buildtrees/{}/install-{}-dbg-out.log'.format(port, triplet)],
      'when': when_clause,
    },
    {
      'name': step_name + '-release-build',
      'image': build_image,
      'commands': ['Get-Content ./buildtrees/{}/install-{}-rel-out.log'.format(port, triplet)],
      'when': when_clause,
    },
  ]

def bundle_requirements(config):
  return {
    'name': 'bundle',
    'image': config['build-image'],
    'commands': ['./Release-Requirements.ps1 -Triplet {}'.format(config['triplet'])],
  }

def release_requirements(config):
  return {
    'name': 'release',
    'image': 'plugins/github-release',
    'pull': 'always',
    'settings': {
      'api_key': {'from_secret': 'github_token'},
      'files': [config['distribution']],
      # Currently the release is manual
      'prerelease': True,
    },
    'when': {
      'event': ['tag'],
    },
  }

#--------------------------------------------------------------------------
# Pipelines
#--------------------------------------------------------------------------

def build_pipeline(triplet):
  config = build_config(triplet)

  # Add initial steps
  build_steps = [
    build_vcpkg(config),
    download_vcpkg_tools(config),
  ]

  for port in config['ports']:
    build_steps.append(build_port(port, config))

  # Add packaging steps
  build_steps.append(bundle_requirements(config))
  build_steps.append(release_requirements(config))

  prev_step = 'clone'
  steps = []

  for step in build_steps:
    step['depends_on'] = [prev_step]
    steps.append(step)
    prev_step = step['name']
    
    # See if there are additional sub steps
    if 'steps' in step:
      sub_steps = step.pop('steps')

      for sub_step in sub_steps:
        sub_step['depends_on'] = [prev_step]
        steps.append(sub_step)

  # Remove the depends_on for the first step to make sure a drone exec works
  # when there is no clone step
  steps[0].pop('depends_on')

  # Create volumes
  volumes = []
  for volume in config['volumes']:
    volume = {
      'name': volume['name'],
      'temp': {},
    }

    volumes.append(volume)

  # Create pipeline
  current = _windows_pipeline(windows_version)
  current['name'] = 'Build {}'.format(triplet)
  current['steps'] = steps
  current['volumes'] = volumes

  return current

def _windows_pipeline(version):
  return {
    'kind': 'pipeline',
    'type': 'docker',
    'platform': {
      'os': 'windows',
      'arch': 'amd64',
      'version': version
    }
  }

#--------------------------------------------------------------------------
# Main
#--------------------------------------------------------------------------

def main(ctx):
  definitions = []

  for triplet in triplets:
    definitions.append(build_pipeline(triplet))

  return definitions
