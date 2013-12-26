require 'spec_helper'

# From valium

describe Pluckeroid do
  context 'with a symbol' do
    subject { Person.value_of :id }
    it { should have(100).ids }
    it { should eq((1..100).to_a) }
  end

  context 'with a string' do
    subject { Person.value_of 'id' }
    it { should have(100).ids }
    it { should eq((1..100).to_a) }
  end

  context 'with multiple values' do
    subject { Person.values_of :id, :last_name }
    it { should have(100).elements }
    it { should eq((1..100).map {|n| [n, "Number#{n}"]})}
  end

  context 'with a datetime column' do
    subject { Person.value_of :created_at }
    it { should have(100).datetimes }
    it { should be_all {|d| Time === d}}
  end

  context 'with a serialized column' do
    subject { Person.value_of :extra_info }
    it { should have(100).hashes }
    it { should eq 1.upto(100).map {|n| {:a_key => "Value Number #{n}"} }}
  end

  context 'with an alternate primary key and an alternate primary key select' do
    subject { Widget.value_of :widget_id }
    it { should have(100).ids }
    it { should eq((1..100).to_a)}
  end

  context 'with a scope' do
    subject { Person.where(:id => [1,50,100]).value_of :last_name }
    it { should have(3).last_names }
    it { should eq ['Number1', 'Number50', 'Number100'] }
  end

  context 'with a scope and value_of syntax' do
    subject { Person.where(:id => [1,50,100]).value_of :id }
    it { should have(3).ids }
    it { should eq [1,50,100] }
  end

  context 'with a scope, an alternate primary key, and an alternate primary key select' do
    subject { Widget.where(:widget_id => [1,50,100]).value_of :widget_id }
    it { should have(3).widget_ids }
    it { should eq [1,50,100]}
  end

  context 'with a scope and multiple keys' do
    subject { Person.where(:id => [1,50,100]).values_of(:last_name, :id, :extra_info) }
    it { should have(3).elements }
    it { should eq [1,50,100].map {|n| ["Number#{n}", n, {:a_key => "Value Number #{n}"}]}}
  end

  context 'with an association' do
    subject { Person.first.widgets.value_of :widget_id }
    it { should have(10).elements }
    it { should eq Person.first.widgets.map(&:id) }
  end

  context 'with joined association' do
    subject { Person.joins(:widgets).value_of :widget_id }
    it { should have(100).ids }
    it { should eq (1..100).to_a }
  end

  context 'with joined association and multiple keys' do
    subject { Person.joins(:widgets).values_of :last_name, :widget_id }
    it { should have(100).elements }
    it { should eq((1..100).map {|n| ["Number#{n % 10 + 1}", n]})}
  end
end
