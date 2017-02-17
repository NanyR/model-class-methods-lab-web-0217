require 'pry'

class Captain < ActiveRecord::Base
  has_many :boats


  def self.catamaran_operators
    # go through boats and from there find relationship to classifications, relying on the boat class defining its relationship to classifications (captain doesn't know about classficiations).same as {boats: :classifications}
    get_boat_type("Catamaran")
    # with_classifications
    # .where(classifications: {name: 'Catamaran'})
  end

  def self.with_classifications
    joins(:boats => :classifications)
  end

  def self.sailors
    # can also use uniq nstead of group
    with_classifications
    .group("captains.name")
    .where(classifications: {name: 'Sailboat'})
    .select(name)
  end

  def self.get_boat_type(type)
    with_classifications
    .where(classifications: {name: type}).uniq
  end

  def self.motorboaters
    get_boat_type("Motorboat")
  end


  def self.talented_seamen
    mb= motorboaters.pluck(:id)
    sb=sailors.pluck(:id)
    where(id: (mb & sb))
  end

  def self.non_sailors
    sailors=self.sailors.pluck(:name)
    all_sailors=self.all.pluck(:name)
    where(name: (all_sailors - sailors))

  end



end
