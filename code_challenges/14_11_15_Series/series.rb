class Series
  attr_reader :series

  def initialize(digits)
    @series = digits.chars.map(&:to_i)
  end

  def slices(slice_size)
    validation(slice_size)

    0.upto(series.size - slice_size).map do |position|
      series.slice(position, slice_size)
    end
  end

  private

  def validation(slice_size)
    fail(ArgumentError, 'You cannot split your series greater than its length!') if series.length < slice_size
  end
end
