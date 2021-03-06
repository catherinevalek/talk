class PostsController < ApplicationController
  def index
		@posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    @votes = @post.votes.sum(:value) 
  end

  # before_action :logged_in_user, only: [:show, :edit, :update, :destroy]
  # before_action :correct_user, only: [:edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.category_id = 1
    @post.poster = current_user
    if @post.save
      flash[:success] = "Post created!"
      redirect_to @post
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:success] = "Your changes have been updated!"
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy 
    Post.find(params[:id]).destroy
    flash[:success] = "post deleted"
    redirect_to posts_url
  end


#   def upvote
#     @post = Post.find(params[:id])
#     # binding.pry
#     new_vote = @post.votes.new(value: 1, votable: @post, voter: current_user)
#     # binding.pry
#       @votes = @post.votes.sum(:value) 
# # binding.pry
#     if new_vote.save
#       # binding.pry
#         # respond_to do |format|
#     # format.html { redirect_to @post }
#     # content_type :json
#     # render :json => { votes: @votes }
#     # binding.pry
#   # end
#       # if request.xhr?
#               # render :partial => "reviews", :layout => false, :locals => { rating: @review}, :formats => [:html]

#         # p "@@@@@@@@@@@@@@@@@@"
#         # content_type :json
#         # render json: { votes: @votes }
#     #   else
#         redirect_to @post
#       # end
#     # else
#     #   status 422
#     end
#   end

  def upvote
    @post = Post.find(params[:id])
    new_vote = @post.votes.new(value: 1, votable: @post, voter: current_user)
    if new_vote.save
      @votes = @post.votes.sum(:value) 
      if request.xhr?
        render json: { votes: @votes }
      else
        redirect_to @post
      end
    else
      status 422
    end
  end

  def downvote
    @post = Post.find(params[:id])
    new_vote = @post.votes.new(value: -1, votable: @post, voter: current_user)
    
    if new_vote.save
      @votes = @post.votes.sum(:value) 
      if request.xhr?
        render json: { votes: @votes }
      else
        redirect_to @post
      end
    else
      status 422
    end
  end

# post '/questions/:id/upvote' do
#   @user = User.find(session[:username])
#   @question = Question.find(params[:id])
#   new_vote = @user.question_votes.new(value: 1, question: @question)

#   # @question.question_votes.create(value: 1, question_id: @question.id, user_id: @user.id)
#   if request.xhr?
#     if new_vote.save
#       @votes = @question.votes
#       content_type :json
#       @votes.to_json
#     else
#       status 422
#     end
#   else
#     redirect "/questions/#{@question.id}"
#   end
# end

# post '/questions/:id/downvote' do
#   @user = User.find(session[:username])
#   @question = Question.find(params[:id])
#   new_vote = @user.question_votes.new(value: -1, question: @question)

#   # @question.question_votes.create(value: -1, question_id: @user.id, user_id: @user.id)
#   if request.xhr?
#     if new_vote.save
#       @votes = @question.votes
#       content_type :json
#       @votes.to_json
#     else
#       status 422
#     end
#   else
#     redirect "/questions/#{@question.id}"
#   end
# end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
