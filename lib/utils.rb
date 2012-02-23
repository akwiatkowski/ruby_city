class Array
  def sum
    inject( nil ) { |sum,x| sum ? sum+x : x }
  end
end

class Time
  def to_s_human_date
    self.strftime('%Y-%m-%d')
  end

  def to_s_human_datetime
    self.strftime('%Y-%m-%d %H-%M-%S')
  end
end

class File
  def self.read_file( filename )
    data = ''
    f = File.open(filename, "r")
    f.each_line do |line|
      data += line
    end
    return data
  end

end