require "test_helper"

class SeatingsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "empty array retuns false" do 
    airplane = AirplaneSeating.new 
    assert_not airplane.set_seats([])
  end

  test "given 1D array returns false" do 
    airplane = AirplaneSeating.new 
    assert_not airplane.set_seats([1,2])
  end

  test "given 2D array returns true" do 
    airplane = AirplaneSeating.new 
    airplane.init
    assert airplane.set_seats([[1,2], [2,3]])
  end

  test "given width and height, returns 2D array" do 
    airplane = AirplaneSeating.new 
    airplane.init 
    seatings = airplane.create_seats(3, 2)
    assert_equal 3, seatings[0].length
    assert_equal 2, seatings.length 
  end

  test "given create_seats, gives max row" do 
    airplane = AirplaneSeating.new 
    airplane.init 
    airplane.set_seats([[3,2], [4,3], [2,3], [3,4]])
    assert_equal 4, airplane.get_max_rows
  end

  test "given create_seats, get aisle seat coordinates" do 
    airplane = AirplaneSeating.new 
    airplane.init 
    airplane.set_seats([[3,2], [4,3], [2,3], [3,4]])
    airplane.place_passengers_to_seats
    expected = [[0, 0, 2], [1, 0, 0], [1, 0, 3], [2, 0, 0], [2, 0, 1], [3, 0, 0], [0, 1, 2], [1, 1, 0], [1, 1, 3], [2, 1, 0], [2, 1, 1], [3, 1, 0], [1, 2, 0], [1, 2, 3], [2, 2, 0], [2, 2, 1], [3, 2, 0], [3, 3, 0]]
    assert_equal expected, airplane.aisles
  end

  test "given create_seats, get window seat coordinates" do 
    airplane = AirplaneSeating.new 
    airplane.init 
    airplane.set_seats([[3,2], [4,3], [2,3], [3,4]])
    airplane.place_passengers_to_seats
    expected = [[0, 0, 0], [3, 0, 2], [0, 1, 0], [3, 1, 2], [3, 2, 2], [3, 3, 2]]
    assert_equal expected, airplane.windows
  end

  test "given create_seats, get middle seat coordinates" do 
    airplane = AirplaneSeating.new 
    airplane.init 
    airplane.set_seats([[3,2], [4,3], [2,3], [3,4]])
    airplane.place_passengers_to_seats
    expected = [[0, 0, 1], [1, 0, 1], [1, 0, 2], [3, 0, 1], [0, 1, 1], [1, 1, 1], [1, 1, 2], [3, 1, 1], [1, 2, 1], [1, 2, 2], [3, 2, 1], [3, 3, 1]]
    assert_equal expected, airplane.middle
  end

  test "given place_passengers_to_seats, get seating matrix" do 
    airplane = AirplaneSeating.new 
    airplane.init 
    airplane.set_seats([[3,2], [4,3]])
    airplane.passengers = 18
    airplane.place_passengers_to_seats
    expected = [[[6, 11, 1], [8, 14, 3]], [[2, 12, 13, 7], [4, 15, 16, 9], [5, 17, 18, 10]]]
    assert_equal expected, airplane.seatings
  end

end
