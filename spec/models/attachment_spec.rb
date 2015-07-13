require 'rails_helper'

describe Attachment do
  it { should validate_presence_of :file }
  it { should belong_to :attachable }
end
