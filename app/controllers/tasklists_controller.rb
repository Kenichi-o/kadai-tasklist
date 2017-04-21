class TasklistsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:edit, :update, :destroy, :show]
  
  def index
    if logged_in?
      @tasklists = current_user.tasklists.page(params[:page])
    end
  end

  def show
    @tasklist = Tasklist.find(params[:id])
  end

  def new
    @tasklist = Tasklist.new
  end

  def create
    @tasklist = Tasklist.new(tasklist_params)
    @tasklist.user_id = current_user.id

    if @tasklist.save
      flash[:success] = 'Task が正常に作成されました'
      redirect_to @tasklist
    else
      flash.now[:danger] = 'Task が正常に作成されませんでした'
      render :new
    end
  end

  def edit
    @tasklist = Tasklist.find(params[:id])
  end

  def update
    @tasklist = Tasklist.find(params[:id])

    if @tasklist.update(tasklist_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @tasklist
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @tasklist = Tasklist.find(params[:id])
    @tasklist.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasklists_url
  end
  
  private

  # Strong Parameter
  def tasklist_params
    params.require(:tasklist).permit(:content)
  end
  
  def correct_user
    @tasklist = current_user.tasklists.find_by(id: params[:id])
    unless @tasklist
      flash[:danger] = '権限がありません'
      redirect_to root_path
    end
  end
end
