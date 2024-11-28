class InvalidFileFormatError < StandardError
  def initialize(msg = "Invalid file format")
    super
  end
end