module StatisticsHelper

  def heatmap_colour(value)
    ["none", "v-low", "low", "medium", "high", "v-high"][value]
  end
   
  def percentage(count, results)
    return count / results[:completed] * 100
  end
   
end