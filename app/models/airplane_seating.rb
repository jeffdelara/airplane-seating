class AirplaneSeating < ApplicationRecord
  attr_accessor :seatings, :passengers, :aisles, :windows, :middle

  def init 
    @seatings = []
    @passengers = 0
    
    # seat coordinates
    @aisles = []
    @windows = []
    @middle = []
  end

  # We take the 2D arrays and create the seats
  def set_seats(arr)
    return false if arr.empty?
    return false if is_2d?(arr) == false

    arr.each_with_index do |coor, index|
      width, height = coor 
      @seatings << create_seats(width, height)
    end
    true
  end

  def create_seats(width, height)
    Array.new(height) { Array.new(width) }
  end

  def place_passengers_to_seats
    # Building the coordinates of the seats mainly aisles, windows and middle
    get_aisle_seats
    get_windows_seats
    get_middle_seats
    
    # These are all the seats coordinates
    seats = @aisles + @windows + @middle
    
    # Start placing passengers to the seats
    passenger = 1
    while !seats.empty? && passenger <= @passengers 
      group, row, col = seats.shift
      @seatings[group][row][col] = passenger
      passenger += 1
    end

    # Return the final seating arrangement
    @seatings
  end

  # Get the coordinates of the aisle seats
  def get_aisle_seats
    last_group = @seatings.length - 1
    for i in (0..last_group)

      if i == 0
        # First group of seats near the window on the left
        @seatings.first.each_with_index do |seat, index|
          last = @seatings[i][index].length - 1
          @aisles << [i, index, last]
        end
      elsif i == last_group
        # First group of seats near window on right
        @seatings.last.each_with_index do |seat, index|
          @aisles << [i, index, 0]
        end
      else  
        @seatings[i].each_with_index do |seat, index|
          mid_group = @seatings[i]
          first = 0 
          last = mid_group[index].length - 1
          @aisles << [i, index, first]
          @aisles << [i, index, last]
        end
      end
    end

    @aisles = sort_seats_by_row(@aisles)
  end


  def get_windows_seats 
    # Get left most coordinates (window)
    @seatings[0].each_with_index do |seat, row|
      @windows << [0, row, 0]
    end

    # Get right most coordinate window
    last = @seatings.length - 1
    @seatings[last].each_with_index do |seat, row|
      window = seat.length - 1
      @windows << [last, row, window]
    end

    @windows = sort_seats_by_row(@windows)
  end

  def get_middle_seats 
    @seatings.each_with_index do |group, g_index|
      group.each_with_index do |rows, r_index|
        rows.each_with_index do |col, c_index|
          if @windows.include?([g_index, r_index, c_index]) || @aisles.include?([g_index, r_index, c_index])
            # coordinates exists in windows or aisles
          else 
            @middle << [g_index, r_index, c_index]
          end
        end
      end
    end
    @middle = sort_seats_by_row(@middle)
  end

  # Sort seats by row (left to right)
  def sort_seats_by_row(seating_coordinates) 
    # group seats by row (left to right)
    seats = {}
    seating_coordinates.each do |coor|
      group, row, col = coor
      if seats.key? row 
        seats[row] << coor
      else 
        seats[row] = [coor]
      end
    end

    # get all coordinates from hash
    seating_order = []
    seats.each do |k,v|
      v.each do |coor|
        seating_order << coor
      end
    end
    seating_order
  end

  def get_max_rows
    max = 0
    @seatings.each do |groups|
      row_length = groups.length
      if max < row_length
        max = row_length
      end
    end
    max
  end

  def get_total_seats 
    (@aisles + @windows + @middle).length
  end

  private 

  def is_2d?(arr)
    arr.all? { |e| e.kind_of? Array } 
  end
end
