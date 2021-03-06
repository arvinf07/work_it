class Workout < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :exercises_workouts
  has_many :exercises, through: :exercises_workouts

  validates :name, presence: true, uniqueness: true
  validates :exercises_workouts, presence: {message: "Sets and reps can't be blank!"}

  accepts_nested_attributes_for :exercises_workouts, reject_if: proc { |attributes| attributes['sets'].blank? || attributes['reps'].blank? } 
 
  scope :alphabetically, ->{ order(:name) }

  def creator
    self.user.name
  end

end
