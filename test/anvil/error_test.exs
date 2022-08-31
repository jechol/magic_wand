defmodule Anvil.ErrorTest do
  use Anvil.Case

  def get_error_struct() do
    err = Error.new({:error, :something_wrong}, :something_wrong, nil)
    # To prevent stack replace.
    Process.sleep(0)
    err
  end

  test "new/1" do
    %Error{
      stacktrace: [top_frame | _rest]
    } = get_error_struct()

    assert {Anvil.ErrorTest, :get_error_struct, 0, _file} = top_frame
  end
end
