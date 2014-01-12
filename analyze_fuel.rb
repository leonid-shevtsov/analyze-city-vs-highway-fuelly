require 'csv'

measurements = CSV.read('fuelups.csv')[2..-1]

def extract_measurements(m)
  total_distance = m[4].to_f
  total_litrage = m[5].to_f
  city_percentage = m[7].to_i/100.0
  city_distance = total_distance*city_percentage
  highway_distance = total_distance*(1-city_percentage)
  [total_litrage, city_distance, highway_distance]
end


highway_litrage_accumulator = 0
city_litrage_accumulator = 0

0.upto(measurements.length-2).each do |i|
  litrage1, city1, highway1 = extract_measurements(measurements[i])
  litrage2, city2, highway2 = extract_measurements(measurements[i+1])

  city_ratio = city2/city1

  highway_litrage = (litrage2-city_ratio*litrage1)/(highway2-city_ratio*highway1)
  city_litrage = (litrage1-highway1*highway_litrage)/city1
  highway_litrage_accumulator += highway_litrage ** 2
  city_litrage_accumulator += city_litrage ** 2
end

highway_litrage = (highway_litrage_accumulator/(measurements.length-1))**0.5
city_litrage = (city_litrage_accumulator/(measurements.length-1))**0.5

puts "Highway litrage: %0.2f L/100km" % (highway_litrage*100)
puts "City litrage: %0.2f L/100km" % (city_litrage*100)

