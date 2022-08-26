=begin
PacmanPackage

Should represent a pacman package.
=end



class PacmanPackage

  #############################################################################
  ### Instance attributes                                                   ###
  #############################################################################
  attr_reader :name
  attr_reader :version
  attr_reader :version_int
  attr_reader :extension
  protected :version_int



  #############################################################################
  ### Instance methods                                                      ###
  #############################################################################

  # Cosntructor. Takes as parameter a dependency package string.
  def initialize( string, extension: "zst" )
    @extension = extension
    string = string.split "="
    @name = string[ 0 ]
    @version = string[ 1 ]
    @version_int = @version.scan( /[0-9]+/ )
    while @version_int.length < 12 do
      @version_int << "0"
    end
    @version_int = @version_int[ 0..11 ]
      .map { |v| "0" * (8 - v.length) + v }
      .join
      .to_i
  end



  # Returns the list of kernel packages to download.
  def package_files
    ret = {
      @name => "#{@name}-#{@version}-x86_64.pkg.tar.#{@extension}"
    }

    if @name.match /^linux/ and !@name.match /headers/ then
      ret[ "#{@name}-headers" ] =
        "#{@name}-headers-#{@version}-x86_64.pkg.tar.#{@extension}"
    end

    return ret.map { |k,v| [ k, [ "#{v}.sig", v ] ] }.to_h
  end



  # Override string coercing.
  def to_s
    return "#{@name}=#{@version}"
  end



  ### Comparison operators
  #############################################################################

  def <=>( other )
    return self.to_s <=> other.to_s
  end

  def ==( other )
    return nil if @name != other.name
    return @version_int == other.version_int
  end

  def !=( other )
    return nil if @name != other.name
    return @version_int != other.version_int
  end

  def >( other )
    return nil if @name != other.name
    return @version_int > other.version_int
  end

  def >=( other )
    return nil if @name != other.name
    return @version_int >= other.version_int
  end

  def <( other )
    return nil if @name != other.name
    return @version_int < other.version_int
  end

  def <=( other )
    return nil if @name != other.name
    return @version_int <= other.version_int
  end



  ### Operators needed by sort/uniq:
  #############################################################################

  def eql? other
    return self == other
  end

  def hash
    return self.to_s.hash
  end

end

