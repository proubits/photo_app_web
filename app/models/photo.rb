class Photo < ActiveRecord::Base
  attr_accessible :location, :name, :taker, :taker_id, :taker_no, :user_id
  validates :taker, :presence => true
  validates :name, :presence => true
  def url(host)
    "http://#{host}/uploads/#{self.taker_id}/#{self.name}.jpg"
  end
  def path(for_thumbnail=false)
    File.join "/", self.taker_id, "#{self.name}#{for_thumbnail ? '_tn' : ''}.jpg"
  end
  def self.associate(user_id, taker_id)
    where(:taker_id => taker_id).each do |p|
      p.update_attribute(:user_id, user_id)
    end
  end
  def self.mine(user_id)
    where(:user_id => user_id).order("id desc")
  end
end
