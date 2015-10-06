require('nokogiri')

# Will stitch together a number of different JPGIS files and convert them into GeoJSON

path = Dir.pwd + "/Japan map/*.xml"

Dir.glob("./Japan map/*.xml") do |xml_file|
  puts "Working on: #{xml_file}..."
  input = File.open(xml_file)
  coordinate_data = Nokogiri::XML(input)
  i = 1
  fname = "hokkaido-#{i}.json"
  output = File.open(fname, "w")

  output.print "{ \"type\": \"MultiLineString\",\n"
  output.print "\"coordinates\": [\n"
  position_coordinates = coordinate_data.search("//gml:posList")
  position_coordinates.each_with_index do |coordinates, index|
    output.print "["
    coordinate_array = coordinates.content.strip.split(/\r?\n/)
    coordinate_array.each_with_index do |coordinate, index|
      output.print coordinate.split(" ").reverse.to_s.gsub(/"/, "") + ((index == coordinate_array.size - 1)? "" : ", ")
    end
    output.print ((index == position_coordinates.size - 1)? "]" : "],\n")
  end
  output.print "]\n}"

  i += 1
  input.close
  output.close
end
