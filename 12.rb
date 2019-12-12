class Position < Struct.new(:x, :y, :z)
  def total
    x.abs + y.abs + z.abs
  end
end

class Velocity < Struct.new(:x, :y, :z)
  def total
    x.abs + y.abs + z.abs
  end
end

class Body
  attr_accessor :position, :velocity

  def x; position.x; end
  def y; position.y; end
  def z; position.z; end
  def vx; velocity.x; end
  def vy; velocity.y; end
  def vz; velocity.z; end

  def initialize(x, y, z)
    @position = Position.new(x, y, z)
    @velocity = Velocity.new(0, 0, 0)
  end

  def energy
    @position.total * @velocity.total
  end
end

class System
  def initialize(bodies)
    @bodies = bodies
  end

  def tick
    # Calculate velocities
    @bodies.permutation(2).each do |(b1, b2)|
      b1.velocity.x += b2.x <=> b1.x
      b1.velocity.y += b2.y <=> b1.y
      b1.velocity.z += b2.z <=> b1.z
    end

    # Update positions
    @bodies.each do |b|
      b.position.x += b.vx
      b.position.y += b.vy
      b.position.z += b.vz
    end
  end

  def vectors
    @bodies.map { |body| [x: body.x, y: body.y, z: body.z, vx: body.vx, vy: body.vy, vz: body.vz ] }
  end

  def velocities
    @bodies.map { |body| [vx: body.vx, vy: body.vy, vz: body.vz ] }
  end

  BIT_WIDTH = 12
  def positions
    @bodies.map { |body| [body.x + 2000, body.y + 2000, body.z + 2000] }
  end

  def to_s
    vectors.map(&:inspect).join("\n")
  end

  def energy
    @bodies.sum(&:energy)
  end
end

# Actual
moons = System.new([
  Body.new(0, 4, 0),
  Body.new(-10, -6, -14),
  Body.new(9, -16, -3),
  Body.new(6, -1, 2)
])

# PART 1
# 1000.times { moons.tick }
# puts moons
# exit
# puts moons.energy

# PART 2

res = []

(0..2).each do |facet|
  hs = {}
  stage = :step1
  step1 = 0

  10000000.times do |i|
    moons.tick
    ps = moons.positions

    amt = (ps[0][facet] << 48) + (ps[1][facet] << 32) + (ps[2][facet] << 16) + ps[3][facet]

    str = amt.to_s

    if hs[str]
      if i - hs[str] == 1 && stage == :step1
        puts "facet #{facet} start: #{i}"
        step1 = i
        stage = :step2
      elsif i - hs[str] == 1 && stage == :step2
        puts "facet #{facet} end  : #{i} ... so #{i - step1} cycle length"
        res << (i - step1)
        stage = :step1
        break
      end
    end

    hs[str] = i
  end

end

puts res.reduce(1, :lcm) * 2