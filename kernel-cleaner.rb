#!/usr/bin/env ruby

class App
  def self.run
    self.new.run
    $stderr.puts "Run this command to purge the packages:"
    $stderr.puts "ruby #{__FILE__} -0 | xargs -0 --no-run-if-empty apt-get purge -y"
  end

  def exec_dpkg_list
    `dpkg -l 'linux-*'`
  end

  def exec_uname_r
    `uname -r`
  end

  def current_version
    trim_version exec_uname_r
  end

  def emergency_version
    installed_packages
    @emergency_version
  end

  def latest_version
    installed_packages
    @latest_version
  end

  def trim_version version
    fail "Unable to parse version: #{version.inspect}" unless version =~ %r{^([0-9.]+(-\d+|))}
    $1
  end

  def installed_packages
    @installed_packages ||= {}.tap do |pkgs|
      exec_dpkg_list.split("\n").each do |line|
        next unless line =~ /^ii/

        parts = line.split(/\s+/)
        name = parts[1]
        version = parts[2]

        if name =~ %r{^linux-image-([0-9.]+-\d+)}
          @emergency_version = @latest_version
          @latest_version = trim_version($1)
        end

        next unless name =~ /^linux-(image|headers)-\d/

        version = trim_version version
        pkgs[version] ||= []
        pkgs[version] << name
      end
    end.freeze
  end

  def obsolete_packages
    pkgs = installed_packages.dup
    pkgs.delete emergency_version
    pkgs.delete latest_version
    pkgs.delete current_version

    pkgs.values.flatten
  end

  def run
    zero_separated = ::ARGV.include?('-0')
    separator = zero_separated ? "\0" : "\n"
    print obsolete_packages.join(separator)
    print separator unless zero_separated
  end
end

if $0 == __FILE__
  App.run
end
