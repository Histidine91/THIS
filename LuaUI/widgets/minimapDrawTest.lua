--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "Minimap draw test",
    desc      = "bla",
    author    = "KingRaptor (L.J. Lim)",
    date      = "Feb 14, 2010",
    license   = "GNU GPL, v2 or later",
    layer     = -1,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local GL_BACK              = GL.BACK
local GL_LEQUAL            = GL.LEQUAL
local GL_LINES             = GL.LINES
local GL_TRIANGLE_FAN      = GL.TRIANGLE_FAN
local glBeginEnd           = gl.BeginEnd
local glBillboard          = gl.Billboard
local glCallList           = gl.CallList
local glColor              = gl.Color
local glCreateList         = gl.CreateList
local glCulling            = gl.Culling
local glDeleteList         = gl.DeleteList
local glDepthTest          = gl.DepthTest
local glDrawGroundCircle   = gl.DrawGroundCircle
local glLighting           = gl.Lighting
local glLineStipple        = gl.LineStipple
local glLoadIdentity       = gl.LoadIdentity
local glPopMatrix          = gl.PopMatrix
local glPushMatrix         = gl.PushMatrix
local glRotate             = gl.Rotate
local glScale              = gl.Scale
local glText               = gl.Text
local glTranslate          = gl.Translate
local glUnitShape          = gl.UnitShape
local glVertex             = gl.Vertex

local planets = {
  {x = Game.mapSizeX * 0.5, z = Game.mapSizeZ * 0.5},
  {x = Game.mapSizeX * 0.25, z = Game.mapSizeZ * 0.75},
  {x = Game.mapSizeX * 0.75, z = Game.mapSizeZ * 0.25},
}

local gaia = Spring.GetGaiaTeamID()
local planet = UnitDefNames.planet.id

local size = math.max(Game.mapSizeX,Game.mapSizeZ) * 60/4096

local function drawMinimapGeos(x,z)
	gl.Vertex(x - size,0,z - size)
	gl.Vertex(x + size,0,z + size)
	gl.Vertex(x + size,0,z - size)
	gl.Vertex(x - size,0,z + size)
end


function widget:DrawInMiniMap(mmsx, mmsy)
	glPushMatrix()
	glLoadIdentity()
	glTranslate(0,1,0)
	glScale(1/Game.mapSizeX, -1/Game.mapSizeZ, 1)
	glRotate(270,1,0,0)
	glLighting(true)
	for i,p in pairs(planets) do
		gl.BeginEnd(GL.LINES,drawMinimapGeos,p.x,p.z)
	end
	glPopMatrix()
	glLighting(false)
end