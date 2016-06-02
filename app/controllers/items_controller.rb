class ItemsController < ApplicationController
	before_action :find_item, only: [:show, :edit, :update, :destroy]
	before_action :authenticate_user!, except: [:index]

	def index
		# The if conditional ensures that the current_user value is not nil. If the if conditional
		# is not there, there will be an error because the id method is being called on a nil value.
		if user_signed_in?
			# Selects the items where the user's id is the same as the current_user.
			# Selects only the checklist items for the current_user.
			@items = Item.where(:user_id => current_user.id).order("created_at DESC")
		end	
	end

	def show
	end

	def new
		@item = current_user.items.build
	end

	def create
		@item = current_user.items.build(item_params)

		if @item.save
			redirect_to root_path
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @item.update(item_params)
			redirect_to root_path
		else
			render 'edit'
		end
	end

	def destroy
		@item.destroy
		redirect_to root_path
	end

	def complete
		@item = Item.find(params[:id])
		@item.update_attribute(:completed_at, Time.now)
		redirect_to root_path, notice: "Item successfully completed!"
	end

	private
		def item_params
			params.require(:item).permit(:title, :description)
		end

		def find_item
			@item = Item.find(params[:id])
		end
end