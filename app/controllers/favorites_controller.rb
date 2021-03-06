# Favorites Controller
#
# Copyright:: (C) 2009 Knowerce, s.r.o.
# 
# Author:: Vojto Rinik <vojto@rinik.net>
# Date: Sep 2009
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

class FavoritesController < ApplicationController
  before_filter :login_required
  
  def new
    @favorite = Favorite.new
    
    respond_to do |wants|
      wants.html
      wants.js
    end
  end
  
  def create
    create_favorite
    load_dataset
    
    respond_to do |wants|
      wants.html { redirect_to request.referer }
      wants.js
    end
    
  end
  
  def destroy
    @favorite = Favorite.find_by_id!(params[:id])
    load_dataset
    @favorite.destroy
    
    respond_to do |wants|
      wants.html { redirect_to request.referer }
      wants.js { render :action => "create" }
    end
  end
  
  protected
  
  def create_favorite
    dataset_description_id = params[:dataset_description_id]
    record_id = params[:record_id]
    
    @favorite = Favorite.new
    @favorite.dataset_description_id = dataset_description_id
    @favorite.record_id = record_id
    @favorite.user_id = current_user.id
    @favorite.note = params[:note]
    
    @favorite.save
  end
  
  def load_dataset
    @dataset_description = @favorite.dataset_description
    @record = @dataset_description.dataset.dataset_record_class.find_by_record_id(@favorite.record_id) if @dataset_description
  end
end
