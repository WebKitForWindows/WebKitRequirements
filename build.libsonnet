local output_file(name, file, image) = {
  name: name,
  image: image,
  pull: 'never',
  commands: [
    'Get-Content ' + file,
  ],
  when: {
    status: ['success', 'failure'],
  },
};

{
  pipeline(name, steps, volumes=[], depends_on=[]):: {
    kind: 'pipeline',
    name: name,
    platform: {
      os: 'windows',
      arch: 'amd64',
    },
    steps: steps,
    volumes: if std.length(volumes) > 0 then volumes,
    depends_on: if std.length(depends_on) > 0 then depends_on,
  },

  vcpkg_build_all(packages, triplet, image, volumes=[], environment=[])::
    std.flattenArrays([
      self.vcpkg_build(package, triplet, image, volumes, environment)
      for package in packages
    ]),

  vcpkg_build(package, triplet, image, volumes=[], environment=[])::
    local package_name = std.split(package, '[')[0];
    [
      {
        name: package_name,
        image: image,
        pull: 'never',
        commands: [
          './vcpkg.exe install ' + package + ' --triplet ' + triplet,
        ],
        volumes: if std.length(volumes) > 0 then volumes,
        environment: if std.length(environment) > 0 then environment,
      },
      output_file(
        package_name + '-config',
        './buildtrees/' + package_name + '/config-' + triplet + '-out.log',
        image,
      ),
      output_file(
        package_name + '-debug-build',
        './buildtrees/' + package_name + '/install-' + triplet + '-dbg-out.log',
        image,
      ),
      output_file(
        package_name + '-release-build',
        './buildtrees/' + package_name + '/install-' + triplet + '-rel-out.log',
        image,
      ),
    ],
}
