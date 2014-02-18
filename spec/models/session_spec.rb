require 'spec_helper'

describe Session do

  it 'includes ActiveModel::ForbiddenAttributesProtection module' do
    Session.new.should be_kind_of(ActiveModel::ForbiddenAttributesProtection)
  end

  it 'includes ActiveModel::Model module' do
    Session.new.should be_kind_of(ActiveModel::Model)
  end

  it 'includes Rails.application.routes.url_helpers module' do
    Session.new.should be_kind_of(Rails.application.routes.url_helpers)
  end

  it 'extends Forwardable module' do
    Session.should be_kind_of(Forwardable)
  end

end
