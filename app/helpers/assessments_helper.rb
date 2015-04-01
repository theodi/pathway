module AssessmentsHelper

  def progress_bar(percent=0)
    content_tag :div, "", id: "progress-bar" do 
      content_tag :div, "", style: "width:#{percent}%;"
    end
  end

end
