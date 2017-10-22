require 'rest-client'
require 'json'
module BluemixHelper
  def post_bluemix(image_obj)
    url = "https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classify?api_key=#{ENV["BLUEMIX_KEY"]}&version=2016-05-20"
    res =  JSON.parse(RestClient.post(url ,
      params: {
        :images_file => image_obj
        }))
    return res
  end

  def request_to_bluemix(image_obj)
    responce = post_bluemix(image_obj)
    scores = responce["images"][0]["classifiers"][0]["classes"]
    res = {}
    scores.each do |score|
      res[score["class"]] = score["score"]
    end
    return res
  end
end
