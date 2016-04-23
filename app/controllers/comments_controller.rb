class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_category, except: [:index, :show]
  before_action :set_theme, except: [:index, :show]
  before_action :set_comment, only: [:edit, :update, :destroy]
  respond_to :js, only: [:edit, :destroy]

  def new
    @comment = @theme.comments.new
  end

  def create
    @comment = @theme.comments.new(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      flash[:success] = 'Your comment is successfully added below!'
    else
      flash[:error] = "Your comment's content can't be blank!"
    end
    redirect_to :back
  end

  def edit; end

  def update
    if @comment.editable?
      flash[:error] = 'Comment can be updated only in 5 minutes after creation.'
    elsif @comment.update_attributes(comment_params)
      flash[:success] = 'Your comment is successfully updated!'
    else
      flash[:error] = "Your comment's content can't be blank!"
    end
    redirect_to :back
  end

  def destroy
    if @comment.destroy
      flash.now[:success] = 'Your comment is successfully deleted!'
    else
      flash.now[:error] = 'Comment was not deleted. Try again.'
    end
    respond_with(@comment) do |format|
      format.html { redirect_to :back }
    end
  end

  private

  def set_category
    category_id = Theme.find(params[:theme_id]).category_id
    @category = Category.find(category_id)
  end

  def set_theme
    @theme = @category.themes.find(params[:theme_id])
  end

  def set_comment
    @comment = @theme.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

end
