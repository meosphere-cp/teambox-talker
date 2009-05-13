require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RoomsController do
  def mock_room(stubs={})
    @mock_room ||= mock_model(Room, stubs)
  end
  
  describe "GET index" do
    it "assigns all rooms as @rooms" do
      Room.stub!(:find).with(:all).and_return([mock_room])
      get :index
      assigns[:rooms].should == [mock_room]
    end
  end

  describe "GET show" do
    it "assigns the requested room as @room" do
      Room.stub!(:find).with("37").and_return(mock_room)
      get :show, :id => "37"
      assigns[:room].should equal(mock_room)
    end
  end

  describe "GET new" do
    it "assigns a new room as @room" do
      Room.stub!(:new).and_return(mock_room)
      get :new
      assigns[:room].should equal(mock_room)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created room as @room" do
        Room.stub!(:new).with({'these' => 'params'}).and_return(mock_room(:save => true))
        post :create, :room => {:these => 'params'}
        assigns[:room].should equal(mock_room)
      end

      it "redirects to the created room" do
        Room.stub!(:new).and_return(mock_room(:save => true))
        post :create, :room => {}
        response.should redirect_to(room_url(mock_room))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved room as @room" do
        Room.stub!(:new).with({'these' => 'params'}).and_return(mock_room(:save => false))
        post :create, :room => {:these => 'params'}
        assigns[:room].should equal(mock_room)
      end

      it "re-renders the 'new' template" do
        Room.stub!(:new).and_return(mock_room(:save => false))
        post :create, :room => {}
        response.should render_template('new')
      end
    end
    
  end
end