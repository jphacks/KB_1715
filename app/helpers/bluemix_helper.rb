require 'rest-client'
require 'json'
module BluemixHelper
  def post_bluemix(image_path)
    res =  JSON.parse(RestClient.post('https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classify?api_key=2926acf03ba0c0bc9bd862a4c6fdbd333a4864c1&version=2016-05-20',
      params: {
        :images_file => File.new(image_path, 'rb')
        }))
    return res
  end

  def request_to_bluemix(image_path)
    image_path = "cat1.jpeg"
    responce = post_bluemix(image_path)
    scores = responce["images"][0]["classifiers"][0]["classes"]
    res = []
    scores.each do |score|
      res.push({score["class"] => score["score"]})
    end
    return res
  end
end
