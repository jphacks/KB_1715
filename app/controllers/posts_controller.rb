# require 'Kconv'
class PostsController < ApplicationController
  include BluemixHelper
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    image = post_params[:imageobject]
    image_name = image.original_filename
    @post.image_name = image.original_filename
    result = uploadimg(image,image_name)
    @post.user_id = current_user.id
    respond_to do |format|
      if result=="success" && @post.save
        format.html { redirect_to @post, notice: '写真を投稿しました。' }
        format.json { render :show, status: :created, location: @post }
      else
        #deleteimg(image_name)
        format.html { render :new }
        flash.now[:alert] = result
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: '写真を変更しました。' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: '写真を削除しました。' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:imageobject, :user_id)
    end
    def uploadimg(img_object,image_name)
      ext = image_name[image_name.rindex('.') + 1, 4].downcase
      perms = ['.jpg', '.jpeg', '.gif', '.png']
      if !perms.include?(File.extname(image_name).downcase)
        result = 'アップロードできるのは画像ファイルのみです。'
      elsif img_object.size > 4.megabyte
        result = 'ファイルサイズは4MBまでです。'
      else
        f = File.open("public/#{image_name.force_encoding("utf-8")}", 'wb')
        f.write(img_object.read)
        f.close()
        scores = request_to_bluemix(File.open("public/#{image_name.force_encoding("utf-8")}", 'rb'))
        if scores.key?("cat") && scores["cat"] > 0.9
          result = "success"
        else
          File.unlink "public/"+image_name.force_encoding("utf-8")
          result = "ねこではないと判断されました"
        end
      end
      return result
    end
    def deleteimg(image_name)
      File.unlink "public/"+image_name.force_encoding("utf-8")
    end
end
