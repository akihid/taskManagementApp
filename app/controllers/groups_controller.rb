class GroupsController < ApplicationController

  before_action :set_group , only:[:edit, :update, :destroy, :show]

  def index
    @groups = Group.all
  end
  def new
    @group = Group.new
  end

  def create
    @group = current_user.groups.build(group_params)
    redirect_to groups_path unless owner?

    if @group.save
      @group.assign_member(current_user)
      flash[:success] = t('msg.new_group_complete')
      redirect_to groups_path
    else
      render 'new'
    end
  end

  def edit
    redirect_to groups_path unless owner?
  end

  def update
    redirect_to groups_path unless owner?
    @group.update(group_params)
    redirect_to groups_path , notice: "グループ「#{@group.name}」を更新しました。"
  end

  def show
    redirect_to groups_path unless assign_group?
  end

  def destroy
    redirect_to groups_path unless owner?
    @group.destroy
    redirect_to groups_path , notice: "グループ「#{@group.name}」を削除しました。"
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end

  def set_group
    @group = Group.find(params[:id])
  end

  def owner?
    return true if @group.owner?(current_user)
    flash[:danger] =  '処理をする権限がありません'
    false
  end

  def assign_group?
    return true if @group.assign?(current_user)
    flash[:danger] =  '参照する権限がありません'
    false
  end
end
