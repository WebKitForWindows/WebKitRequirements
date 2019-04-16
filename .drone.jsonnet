local build = import 'build.libsonnet';
local targets = import 'WinCairoRequirements.json';
local image = 'webkitdev/msbuild:1809';

local pipeline(name, triplet, archive) = build.pipeline(
  name,
  [
    // Build out vcpkg executable
    {
      name: 'vcpkg',
      image: image,
      pull: 'never',
      commands: [
        'git clone https://github.com/Microsoft/vcpkg.git C:/vcpkg',
        'cd C:/vcpkg',
        'Invoke-Expression -Command ./scripts/bootstrap.ps1',
        'cp .vcpkg-root C:/drone/src',
        'cp vcpkg.exe C:/drone/src',
        'cp -r scripts C:/drone/src',
      ],
    },
  ] + 
  build.vcpkg_build_all(targets + ['pthreads', 'cflite'], triplet, image) +
  [
    // Prepare release
    {
      name: 'bundle',
      image: image,
      pull: 'never',
      commands: [
        'Invoke-Expression -Command "./Delete-PthreadHeaders.ps1 -Triplet ' + triplet + '"',
        'Invoke-Expression -Command "./Rename-WithBitSuffix.ps1 -Triplet ' + triplet + '"',
        'Invoke-Expression -Command "./Package-Requirements.ps1 -Triplet ' + triplet + ' -Output ' + archive + '.zip"',
      ],
    },
    {
      name: 'release',
      image: 'plugins/github-release',
      settings: {
        api_key: {
          from_secret: 'github_token',
        },
        prerelease: true,
        files: [archive + '.zip']
      },
      when: {
        event: ['tag'],
      },
    },
  ]
);

[
  pipeline('x64', 'x64-windows-webkit', 'WinCairoRequirements'),
  pipeline('x86', 'x86-windows-webkit', 'WinCairoRequirementsX86'),
]
