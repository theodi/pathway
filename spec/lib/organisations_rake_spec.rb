require 'spec_helper'
require 'rake'

describe 'organisations.rake' do 
  
  before { ODMAT::Application.load_tasks }
  it { expect { Rake::Task['organisations:import'].invoke }.not_to raise_exception }
  
end
