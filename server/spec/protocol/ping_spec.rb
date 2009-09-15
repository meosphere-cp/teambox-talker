require File.dirname(__FILE__) + "/../spec_helper"

describe "ping message" do
  before do
    @connection = create_connection
    @connection.room = mock("room")
    @connection.user_name = "tester"
  end
  
  it "should be ignored" do
    @connection.send_message("type" => "ping")
  end
end
