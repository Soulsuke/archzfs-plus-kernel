=begin
PacmanDbParser

This class is made to parse a pacman repository and extract a list of
packages from it.

NOTE: this is a quick and dirty way to achieve the goal, and is designed to be
      used on quite small repositories.
      For any other use you'll need to use libalpm bindings.
=end



require "xz"
require_relative "pacman_package"



class PacmanDbParser

  #############################################################################
  ### Attributes                                                            ###
  #############################################################################

  attr_reader :data



  #############################################################################
  ### Public methods                                                        ###
  #############################################################################

  # Constructor.
  def initialize( repo_data )
    @data = Array.new

    # Control variables:
    next_info = nil

    # Parse each line:
    XZ.decompress( repo_data ).each_line do |l|
      # Clean it up a little:
      l = l.strip

      case l
        when /%FILENAME%/
          next_info = :file_name
          @data << Hash.new

        when /%NAME%/
          next_info = :pkg_name

         when /%VERSION%/
          next_info = :version

         when /%DEPENDS%/
           next_info = :k_depends

        else
          if l.match /%/ or l.empty? then
            next_info = nil

          elsif !next_info.nil? then
            if next_info == :k_depends and l.match /linux/ and
               !l.match /spl/ \
            then
              @data[ -1 ][ :k_depends ] = PacmanPackage.new l
            else
              @data[ -1 ][ next_info ] = l
              if :version == next_info then
                @data[ -1 ][ :pkg ] = PacmanPackage.new(
                  "#{@data[ -1 ][ :pkg_name ]}=#{@data[ -1 ][ :version ]}",
                    extension: @data[ -1 ][ :file_name ].split( "." )[ -1 ]
                )
              end
            end
          end
      end
    end

    @data = @data.map { |r|
        [ r[ :pkg_name ], r.filter { |k,v| k != :pkg_name } ]
      }.to_h
  end


 
  def pkgs
    return @data.map { |k,v| v[ :pkg ] }
  end

  def kernel_deps
    return @data.map { |k,v| v[ :k_depends ] }.sort.uniq
  end
 
  def pkgs_with_kernel_deps
    return (pkgs + kernel_deps).sort.uniq
  end

end



###############################################################################
### Quick tester                                                            ###
###############################################################################

if __FILE__ == $0 then
  db = PacmanDbParser.new File.read ARGV[ 0 ]
  puts db.data
  puts "=" * 80
  puts db.pkgs
  puts "=" * 80
  puts db.kernel_deps
  puts "=" * 80
  puts db.pkgs_with_kernel_deps
  puts "=" * 80
  db.pkgs.each do |p|
    puts p.package_files
  end
end

