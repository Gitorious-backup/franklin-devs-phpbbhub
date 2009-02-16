# encoding: utf-8
#--
#   Copyright (C) 2009 Johan Sørensen <johan@johansorensen.com>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++


require File.dirname(__FILE__) + '/../test_helper'

class PagesControllerTest < ActionController::TestCase


  def setup
    @project = projects(:johans)
    @repo = @project.wiki_repository
    #authorize_as :johan
  end
  
  context "repository readyness" do
    should " be ready on #index" do
      Repository.any_instance.stubs(:ready?).returns(false)
      get :index, :project_id => @project.to_param
      assert_redirected_to(project_path(@project))
      assert_match(/is being created/, flash[:notice])
    end
    
    should " be ready on #show" do
      Repository.any_instance.stubs(:ready?).returns(false)
      get :show, :project_id => @project.to_param, :id => "Home"
      assert_redirected_to(project_path(@project))
      assert_match(/is being created/, flash[:notice])
    end
  end
  
  context "index" do
    should "renders an index" do
      git_stub = stub("git", {
        :tree => stub(:contents => [mock("node", :name => "Foo"), mock("node", :name => "Bar")])
      })
      Repository.any_instance.stubs(:git).returns(git_stub)
      get :index, :project_id => @project.to_param
      assert_response :success
    end
    
    should "redirects to the project if wiki is disabled for this projcet" do
      @project.update_attribute(:wiki_enabled, false)
      get :index, :project_id => @project.to_param
      assert_redirected_to(project_path(@project))
    end
  end
  
  context "show" do
    should "redirects to edit if the page is new" do
      page_stub = mock("page stub")
      page_stub.expects(:new?).returns(true)
      Repository.any_instance.expects(:git).returns(mock("git"))
      Page.expects(:find).returns(page_stub)
      
      get :show, :project_id => @project.to_param, :id => "Home"
      assert_redirected_to(edit_project_page_path(@project, "Home"))
    end
    
    should "redirects to the project if wiki is disabled for this projcet" do
      @project.update_attribute(:wiki_enabled, false)
      get :show, :project_id => @project.to_param, :id => "Foo"
      assert_redirected_to(project_path(@project))
    end
  end
  
end