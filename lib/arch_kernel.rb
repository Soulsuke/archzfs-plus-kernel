=begin
Package class.
=end

class ArchKernel

  #############################################################################
  ### Instance attributes                                                   ###
  #############################################################################
  attr_reader :name
  attr_reader :version
  attr_reader :version_int
  protected :version_int



  #############################################################################
  ### Instance methods                                                      ###
  #############################################################################

  # Cosntructor. Takes as parameter a dependency package string.
  def initialize( string )
    string = string.split "="
    @name = string[ 0 ]
    @version = string[ 1 ]
    @version_int = @version.scan( /[0-9]+/ )
    while @version_int.length < 5 do
      @version_int << "0"
    end
    @version_int = @version_int
      .map { |v| "0" * (3 - v.length) + v }
      .join
      .to_i
  end



  # Returns the list of kernel packages to download.
  def packages
    return {
      @name => "#{@name}-#{@version}-x86_64.pkg.tar.zst",
      "#{@name}-headers" => "#{@name}-headers-#{@version}-x86_64.pkg.tar.zst"
    }.map { |k,v| [ k, [ "#{v}.sig", v ] ] }.to_h
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

end

