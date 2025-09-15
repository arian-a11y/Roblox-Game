-- Arena Generator for Fighting Game
-- Creates dynamic fighting arenas with different themes and layouts
-- MASSIVE EXPANSION: Comprehensive arena generation system with procedural elements

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local PathfindingService = game:GetService("PathfindingService")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local PhysicsService = game:GetService("PhysicsService")

local ArenaGenerator = {}

-- Advanced mathematical constants for procedural generation
local GOLDEN_RATIO = 1.61803398875
local PHI = 1.618033988749
local E = 2.718281828459
local PI_SQUARED = math.pi * math.pi
local SQRT_2 = math.sqrt(2)
local SQRT_3 = math.sqrt(3)
local FIBONACCI_SEQUENCE = {1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987}

-- Noise generation seeds for procedural elements
local PERLIN_NOISE_SEEDS = {
    TERRAIN = 12345,
    DECORATION = 67890,
    LIGHTING = 54321,
    WEATHER = 98765,
    HAZARDS = 13579,
    STRUCTURES = 24680,
    VEGETATION = 11111,
    MINERALS = 22222,
    WATER = 33333,
    ATMOSPHERE = 44444
}

-- Complex arena data structure with procedural generation parameters
ArenaGenerator.Arenas = {
    ANCIENT_TEMPLE = {
        name = "Ancient Temple",
        size = Vector3.new(100, 10, 100),
        spawnHeight = 15,
        difficulty = "MEDIUM",
        biome = "DESERT",
        weatherPattern = "SANDSTORM",
        timeOfDay = "SUNSET",
        geologicalFormation = "PLATEAU",
        architecturalStyle = "MESOPOTAMIAN",
        culturalInfluence = "BABYLONIAN",
        historicalPeriod = "BRONZE_AGE",
        mysticalElements = true,
        ancientPowers = {"EARTH", "SAND", "TIME"},
        runeTypes = {"PROTECTION", "STRENGTH", "WISDOM", "ENDURANCE"},
        theme = {
            primaryColor = Color3.fromRGB(139, 119, 101),
            secondaryColor = Color3.fromRGB(205, 175, 149),
            accentColor = Color3.fromRGB(255, 215, 0),
            shadowColor = Color3.fromRGB(69, 59, 51),
            highlightColor = Color3.fromRGB(255, 235, 205),
            material = Enum.Material.Sandstone,
            alternativeMaterials = {Enum.Material.Rock, Enum.Material.Concrete, Enum.Material.Brick}
        },
        lighting = {
            ambient = Color3.fromRGB(100, 80, 60),
            brightness = 2,
            clockTime = 14,
            fogEnd = 200,
            fogColor = Color3.fromRGB(255, 200, 150),
            shadows = true,
            volumetricLighting = true,
            godrays = true,
            dustParticles = true,
            ambientOcclusion = 0.7,
            bloomIntensity = 0.3,
            contrast = 1.2,
            saturation = 0.9
        },
        acoustics = {
            reverbType = "CANYON",
            echoDelay = 0.8,
            resonanceFrequency = 120,
            ambientSounds = {"WIND_DESERT", "ANCIENT_CHANTS", "STONE_CREAKING", "SAND_SHIFTING"},
            musicTheme = "EPIC_ORCHESTRAL",
            dynamicAudioLayers = true
        },
        decorations = {
            "massive_pillars", "torch_braziers", "ancient_runes", "stone_steps", "hieroglyphic_walls",
            "golden_statues", "crystal_formations", "sand_dunes", "obelisks", "pyramid_structures",
            "sphinx_guardians", "sacred_altars", "mystical_portals", "floating_stones", "energy_crystals",
            "ancient_machinery", "celestial_alignments", "temporal_rifts", "divine_symbols", "warrior_statues"
        },
        proceduralElements = {
            terrainComplexity = 0.8,
            structuralVariation = 0.9,
            decorativeAbundance = 0.7,
            mysticalIntensity = 0.8,
            weatherIntensity = 0.6,
            hazardDensity = 0.4,
            secretAreas = 3,
            hiddenPassages = 2,
            emergentGameplay = true
        },
        environmentalHazards = {
            "SANDSTORM_ZONES", "QUICKSAND_PITS", "FALLING_DEBRIS", "ANCIENT_TRAPS", "MYSTICAL_BARRIERS",
            "TEMPORAL_DISTORTIONS", "CURSED_GROUNDS", "PRESSURE_PLATES", "SPIKE_TRAPS", "ILLUSION_WALLS"
        },
        interactiveElements = {
            "LEVER_MECHANISMS", "ROTATING_PLATFORMS", "SLIDING_WALLS", "ELEVATING_PLATFORMS", "BRIDGE_CONTROLS",
            "ANCIENT_SWITCHES", "CRYSTAL_ACTIVATION", "RUNE_SEQUENCES", "PRESSURE_PUZZLES", "LIGHT_REDIRECTORS"
        },
        dynamicEvents = {
            "PILLAR_COLLAPSE", "SAND_ERUPTION", "MYSTICAL_SURGE", "ANCIENT_AWAKENING", "CELESTIAL_ALIGNMENT",
            "TEMPORAL_SHIFT", "GUARDIAN_EMERGENCE", "TREASURE_REVEAL", "CURSE_ACTIVATION", "DIVINE_INTERVENTION"
        }
    },
    
    NEON_CYBERPUNK = {
        name = "Neon Arena",
        size = Vector3.new(80, 8, 80),
        spawnHeight = 12,
        difficulty = "HARD",
        biome = "URBAN",
        weatherPattern = "ELECTRIC_STORM",
        timeOfDay = "MIDNIGHT",
        geologicalFormation = "ARTIFICIAL",
        architecturalStyle = "FUTURISTIC",
        culturalInfluence = "CYBERPUNK",
        historicalPeriod = "FUTURE",
        mysticalElements = false,
        technologicalLevel = "ADVANCED",
        dataStreams = {"FINANCIAL", "SURVEILLANCE", "COMMUNICATION", "ENTERTAINMENT"},
        hackingNodes = {"SECURITY", "LIGHTING", "PLATFORMS", "BARRIERS"},
        theme = {
            primaryColor = Color3.fromRGB(20, 20, 30),
            secondaryColor = Color3.fromRGB(40, 40, 60),
            accentColor = Color3.fromRGB(0, 255, 255),
            neonColors = {
                Color3.fromRGB(255, 0, 255), -- Magenta
                Color3.fromRGB(0, 255, 0),   -- Green
                Color3.fromRGB(255, 255, 0), -- Yellow
                Color3.fromRGB(255, 100, 0), -- Orange
                Color3.fromRGB(100, 0, 255)  -- Purple
            },
            shadowColor = Color3.fromRGB(10, 10, 15),
            highlightColor = Color3.fromRGB(255, 255, 255),
            material = Enum.Material.Neon,
            alternativeMaterials = {Enum.Material.Glass, Enum.Material.Metal, Enum.Material.Plastic}
        },
        lighting = {
            ambient = Color3.fromRGB(50, 50, 100),
            brightness = 1,
            clockTime = 0,
            fogEnd = 100,
            fogColor = Color3.fromRGB(100, 0, 200),
            shadows = true,
            volumetricLighting = true,
            neonGlow = true,
            digitalEffects = true,
            ambientOcclusion = 0.9,
            bloomIntensity = 0.8,
            contrast = 1.5,
            saturation = 1.3,
            chromaticAberration = 0.2,
            scanlines = true,
            pixelDistortion = 0.1
        },
        acoustics = {
            reverbType = "ELECTRONIC",
            echoDelay = 0.3,
            resonanceFrequency = 440,
            ambientSounds = {"ELECTRIC_HUM", "DATA_PROCESSING", "NEON_BUZZ", "HOLOGRAM_FLICKER"},
            musicTheme = "SYNTHWAVE",
            dynamicAudioLayers = true,
            bassBoost = 1.5,
            digitalDistortion = 0.3
        },
        decorations = {
            "neon_strips", "holographic_displays", "cyber_pillars", "data_stream_effects", "digital_billboards",
            "floating_screens", "laser_grids", "energy_conduits", "server_towers", "quantum_processors",
            "artificial_intelligence_cores", "robotic_sentinels", "plasma_containers", "electromagnetic_fields",
            "virtual_reality_portals", "augmented_reality_overlays", "neural_interfaces", "cybernetic_implants",
            "digital_waterfalls", "pixelated_structures", "glitch_effects", "matrix_code", "firewall_barriers",
            "encryption_locks", "biometric_scanners", "drone_stations", "charging_pods", "teleportation_arrays"
        },
        proceduralElements = {
            terrainComplexity = 0.6,
            structuralVariation = 1.0,
            decorativeAbundance = 0.9,
            technologicalIntensity = 1.0,
            weatherIntensity = 0.8,
            hazardDensity = 0.7,
            secretAreas = 4,
            hiddenPassages = 5,
            emergentGameplay = true,
            proceduralGenerationSeed = 42
        },
        environmentalHazards = {
            "ELECTRIC_FIELDS", "LASER_BARRIERS", "PLASMA_STORMS", "DATA_CORRUPTION_ZONES", "SYSTEM_OVERLOADS",
            "HOLOGRAM_MAZES", "MAGNETIC_INTERFERENCE", "QUANTUM_FLUCTUATIONS", "VIRTUAL_VIRUSES", "CYBER_ATTACKS",
            "ELECTROMAGNETIC_PULSES", "NEURAL_FEEDBACK", "DIGITAL_PHANTOMS", "GLITCH_ANOMALIES", "FIREWALL_LOCKS"
        },
        interactiveElements = {
            "TERMINAL_HACKING", "HOLOGRAM_PROJECTION", "ENERGY_REDISTRIBUTION", "PLATFORM_RECONFIGURATION",
            "SECURITY_OVERRIDE", "DATA_MINING", "NETWORK_BRIDGING", "VIRTUAL_CONSTRUCTION", "AI_COMMUNICATION",
            "QUANTUM_ENTANGLEMENT", "DIGITAL_ARCHAEOLOGY", "CYBER_INFILTRATION", "SYSTEM_ADMINISTRATION",
            "AUGMENTED_REALITY_MANIPULATION", "NEURAL_LINK_ESTABLISHMENT"
        },
        dynamicEvents = {
            "SYSTEM_CRASH", "VIRAL_OUTBREAK", "AI_REBELLION", "QUANTUM_STORM", "DATA_BREACH", "NETWORK_INVASION",
            "HOLOGRAM_MALFUNCTION", "POWER_SURGE", "DIGITAL_EARTHQUAKE", "CYBER_TORNADO", "MATRIX_REVOLUTION",
            "VIRTUAL_APOCALYPSE", "TECHNOLOGICAL_SINGULARITY", "DIGITAL_EVOLUTION", "CYBER_TRANSCENDENCE"
        }
    },
    
    VOLCANIC_CRATER = {
        name = "Volcanic Crater",
        size = Vector3.new(120, 15, 120),
        spawnHeight = 20,
        difficulty = "EXTREME",
        biome = "VOLCANIC",
        weatherPattern = "LAVA_RAIN",
        timeOfDay = "ETERNAL_TWILIGHT",
        geologicalFormation = "CALDERA",
        architecturalStyle = "NATURAL",
        culturalInfluence = "PRIMORDIAL",
        historicalPeriod = "PREHISTORIC",
        mysticalElements = true,
        elementalForces = {"FIRE", "EARTH", "MAGMA", "SULFUR"},
        magmaTypes = {"BASALTIC", "ANDESITIC", "RHYOLITIC", "OBSIDIAN"},
        theme = {
            primaryColor = Color3.fromRGB(60, 30, 30),
            secondaryColor = Color3.fromRGB(120, 60, 60),
            accentColor = Color3.fromRGB(255, 100, 0),
            lavaColors = {
                Color3.fromRGB(255, 69, 0),   -- Red-Orange
                Color3.fromRGB(255, 140, 0),  -- Dark Orange
                Color3.fromRGB(255, 215, 0),  -- Gold
                Color3.fromRGB(255, 255, 0),  -- Yellow
                Color3.fromRGB(255, 20, 20)   -- Bright Red
            },
            shadowColor = Color3.fromRGB(20, 10, 10),
            highlightColor = Color3.fromRGB(255, 200, 100),
            material = Enum.Material.Rock,
            alternativeMaterials = {Enum.Material.Basalt, Enum.Material.CorrodedMetal, Enum.Material.Concrete}
        },
        lighting = {
            ambient = Color3.fromRGB(150, 50, 0),
            brightness = 3,
            clockTime = 18,
            fogEnd = 150,
            fogColor = Color3.fromRGB(255, 100, 50),
            shadows = true,
            volumetricLighting = true,
            lavaGlow = true,
            heatShimmer = true,
            ambientOcclusion = 0.8,
            bloomIntensity = 0.9,
            contrast = 1.4,
            saturation = 1.1,
            thermodynamicEffects = true,
            radiationHaze = 0.3
        },
        acoustics = {
            reverbType = "CAVERN",
            echoDelay = 1.2,
            resonanceFrequency = 80,
            ambientSounds = {"LAVA_BUBBLING", "ROCK_CRACKING", "VOLCANIC_RUMBLING", "STEAM_HISSING"},
            musicTheme = "DRAMATIC_PERCUSSION",
            dynamicAudioLayers = true,
            bassRumble = 2.0,
            trebleHiss = 1.3
        },
        decorations = {
            "lava_pools", "rock_formations", "steam_vents", "ember_effects", "crystalline_formations",
            "volcanic_glass", "pumice_deposits", "sulfur_crystals", "obsidian_spires", "magma_tubes",
            "geothermal_springs", "mineral_veins", "petrified_trees", "volcanic_bombs", "lava_tubes",
            "pyroclastic_flows", "fumaroles", "hot_springs", "volcanic_ash_deposits", "basalt_columns",
            "lava_fountains", "thermal_pools", "molten_rivers", "fire_geysers", "plasma_storms",
            "elemental_spirits", "phoenix_nests", "dragon_bones", "salamander_colonies", "fire_elementals"
        },
        proceduralElements = {
            terrainComplexity = 1.0,
            structuralVariation = 0.8,
            decorativeAbundance = 0.8,
            elementalIntensity = 1.0,
            weatherIntensity = 1.0,
            hazardDensity = 0.9,
            secretAreas = 2,
            hiddenPassages = 3,
            emergentGameplay = true,
            magmaFlowPatterns = true,
            thermalDynamics = true
        },
        environmentalHazards = {
            "LAVA_GEYSERS", "TOXIC_GASES", "FALLING_METEORS", "PYROCLASTIC_FLOWS", "THERMAL_SHOCK",
            "GROUND_FISSURES", "VOLCANIC_LIGHTNING", "ASH_STORMS", "MAGMA_ERUPTIONS", "HEAT_WAVES",
            "SULFUR_CLOUDS", "MOLTEN_RAIN", "FIRE_TORNADOES", "LAVA_TSUNAMIS", "VOLCANIC_EARTHQUAKES"
        },
        interactiveElements = {
            "LAVA_FLOW_CONTROL", "STEAM_PRESSURE_VALVES", "THERMAL_ENERGY_HARVESTING", "VOLCANIC_TIMING",
            "MAGMA_REDIRECTION", "HEAT_SHIELDING", "MINERAL_EXTRACTION", "GEOTHERMAL_POWER", "FIRE_MASTERY",
            "ELEMENTAL_SUMMONING", "VOLCANIC_PROPHECY", "THERMAL_NAVIGATION", "PYROCLASTIC_SURFING",
            "LAVA_WALKING", "FIRE_IMMUNITY_RITUALS"
        },
        dynamicEvents = {
            "MAJOR_ERUPTION", "LAVA_LAKE_FORMATION", "VOLCANIC_WINTER", "MAGMA_CHAMBER_COLLAPSE", "RING_OF_FIRE",
            "SUPERVOLCANIC_AWAKENING", "ELEMENTAL_CONVERGENCE", "PRIMORDIAL_EMERGENCE", "FIRE_APOCALYPSE",
            "VOLCANIC_REBIRTH", "PHOENIX_RESURRECTION", "DRAGON_AWAKENING", "ELEMENTAL_WAR", "THERMAL_CATACLYSM",
            "MOLTEN_CORE_EXPOSURE"
        }
    },
    
    ICE_FORTRESS = {
        name = "Ice Fortress",
        size = Vector3.new(90, 12, 90),
        spawnHeight = 16,
        difficulty = "HARD",
        biome = "ARCTIC",
        weatherPattern = "BLIZZARD",
        timeOfDay = "POLAR_NIGHT",
        geologicalFormation = "GLACIER",
        architecturalStyle = "CRYSTALLINE",
        culturalInfluence = "NORDIC",
        historicalPeriod = "ICE_AGE",
        mysticalElements = true,
        elementalForces = {"ICE", "WIND", "FROST", "SNOW"},
        crystallineStructures = {"HEXAGONAL", "CUBIC", "PRISMATIC", "DENDRITIC"},
        theme = {
            primaryColor = Color3.fromRGB(200, 230, 255),
            secondaryColor = Color3.fromRGB(150, 200, 255),
            accentColor = Color3.fromRGB(100, 150, 255),
            iceColors = {
                Color3.fromRGB(240, 248, 255), -- Alice Blue
                Color3.fromRGB(176, 224, 230), -- Powder Blue
                Color3.fromRGB(135, 206, 235), -- Sky Blue
                Color3.fromRGB(70, 130, 180),  -- Steel Blue
                Color3.fromRGB(25, 25, 112)    -- Midnight Blue
            },
            shadowColor = Color3.fromRGB(100, 120, 140),
            highlightColor = Color3.fromRGB(255, 255, 255),
            material = Enum.Material.Ice,
            alternativeMaterials = {Enum.Material.Glass, Enum.Material.Marble, Enum.Material.ForceField}
        },
        lighting = {
            ambient = Color3.fromRGB(150, 180, 255),
            brightness = 1.5,
            clockTime = 12,
            fogEnd = 300,
            fogColor = Color3.fromRGB(200, 220, 255),
            shadows = true,
            volumetricLighting = true,
            crystallineRefraction = true,
            auroraEffects = true,
            ambientOcclusion = 0.6,
            bloomIntensity = 0.4,
            contrast = 1.1,
            saturation = 0.8,
            iceReflection = 1.2,
            prismaticDispersion = 0.3
        },
        acoustics = {
            reverbType = "ICE_CAVE",
            echoDelay = 1.5,
            resonanceFrequency = 200,
            ambientSounds = {"WIND_HOWLING", "ICE_CRACKING", "SNOW_FALLING", "AURORA_HUMMING"},
            musicTheme = "ETHEREAL_AMBIENT",
            dynamicAudioLayers = true,
            crystallineResonance = 1.8,
            acousticClarity = 2.0
        },
        decorations = {
            "ice_spikes", "frozen_waterfalls", "crystal_formations", "snowfall_effects", "ice_sculptures",
            "glacial_crevasses", "ice_bridges", "frozen_lakes", "icicle_chandeliers", "snow_drifts",
            "aurora_displays", "ice_labyrinths", "frozen_gardens", "crystalline_towers", "ice_thrones",
            "frozen_fountains", "ice_mirrors", "crystal_prisons", "frozen_time_capsules", "ice_dungeons",
            "arctic_wildlife", "ice_dragons", "frost_giants", "snow_angels", "winter_spirits",
            "crystalline_libraries", "frozen_archives", "ice_observatories", "arctic_sanctuaries", "polar_temples"
        },
        proceduralElements = {
            terrainComplexity = 0.9,
            structuralVariation = 0.8,
            decorativeAbundance = 0.7,
            elementalIntensity = 0.9,
            weatherIntensity = 0.9,
            hazardDensity = 0.6,
            secretAreas = 5,
            hiddenPassages = 4,
            emergentGameplay = true,
            crystallineGrowth = true,
            thermalDynamics = true
        },
        environmentalHazards = {
            "ICE_STORMS", "HYPOTHERMIA_ZONES", "AVALANCHES", "CREVASSE_FALLS", "FREEZING_WINDS",
            "ICE_SHARDS", "SLIPPERY_SURFACES", "FROST_BITE", "SNOW_BLINDNESS", "ARCTIC_PREDATORS",
            "FROZEN_TRAPS", "ICE_QUAKES", "POLAR_VORTEX", "CRYSTALLINE_MAZES", "THERMAL_SHOCK"
        },
        interactiveElements = {
            "ICE_MELTING", "SNOW_MANIPULATION", "CRYSTALLINE_RESONANCE", "AURORA_CONTROL", "THERMAL_REGULATION",
            "GLACIAL_MOVEMENT", "ICE_CONSTRUCTION", "FROZEN_TIME", "ARCTIC_NAVIGATION", "WINTER_MAGIC",
            "CRYSTALLINE_COMMUNICATION", "ICE_PROPHECY", "POLAR_ALIGNMENT", "FROST_MASTERY", "ARCTIC_SURVIVAL"
        },
        dynamicEvents = {
            "GREAT_FREEZE", "AURORA_STORM", "GLACIAL_SHIFT", "ICE_AGE_RETURN", "CRYSTALLINE_AWAKENING",
            "POLAR_REVERSAL", "WINTER_ETERNAL", "ICE_DRAGON_EMERGENCE", "ARCTIC_CONVERGENCE", "FROZEN_APOCALYPSE",
            "CRYSTALLINE_EVOLUTION", "POLAR_TRANSCENDENCE", "ICE_PHOENIX_REBIRTH", "ARCTIC_ENLIGHTENMENT",
            "WINTER_SOLSTICE_MAXIMUM"
        }
    },
    
    FLOATING_PLATFORMS = {
        name = "Sky Temple",
        size = Vector3.new(70, 5, 70),
        spawnHeight = 500,
        difficulty = "MEDIUM",
        biome = "AERIAL",
        weatherPattern = "WIND_CURRENTS",
        timeOfDay = "DAWN",
        geologicalFormation = "SUSPENDED",
        architecturalStyle = "CELESTIAL",
        culturalInfluence = "ANGELIC",
        historicalPeriod = "DIVINE",
        mysticalElements = true,
        elementalForces = {"AIR", "LIGHT", "GRAVITY", "SPACE"},
        celestialBodies = {"SUN", "MOON", "STARS", "COMETS"},
        theme = {
            primaryColor = Color3.fromRGB(255, 255, 255),
            secondaryColor = Color3.fromRGB(240, 240, 255),
            accentColor = Color3.fromRGB(255, 215, 0),
            skyColors = {
                Color3.fromRGB(135, 206, 235), -- Sky Blue
                Color3.fromRGB(255, 218, 185), -- Peach Puff
                Color3.fromRGB(255, 160, 122), -- Light Salmon
                Color3.fromRGB(255, 105, 180), -- Hot Pink
                Color3.fromRGB(147, 112, 219)  -- Medium Purple
            },
            shadowColor = Color3.fromRGB(200, 200, 220),
            highlightColor = Color3.fromRGB(255, 255, 255),
            material = Enum.Material.Marble,
            alternativeMaterials = {Enum.Material.Glass, Enum.Material.ForceField, Enum.Material.Neon}
        },
        lighting = {
            ambient = Color3.fromRGB(200, 200, 255),
            brightness = 2,
            clockTime = 10,
            fogEnd = 1000,
            fogColor = Color3.fromRGB(135, 206, 235),
            shadows = true,
            volumetricLighting = true,
            celestialRays = true,
            divineIllumination = true,
            ambientOcclusion = 0.3,
            bloomIntensity = 0.6,
            contrast = 1.0,
            saturation = 1.0,
            heavenlyGlow = 1.5,
            etherealMist = 0.4
        },
        acoustics = {
            reverbType = "HEAVENLY",
            echoDelay = 2.0,
            resonanceFrequency = 528,
            ambientSounds = {"CELESTIAL_CHOIR", "WIND_WHISPERS", "ANGELIC_BELLS", "COSMIC_HARMONY"},
            musicTheme = "ORCHESTRAL_DIVINE",
            dynamicAudioLayers = true,
            harmonicResonance = 2.5,
            etherealEcho = 3.0
        },
        decorations = {
            "floating_rocks", "cloud_effects", "golden_trim", "wind_effects", "celestial_bodies",
            "floating_gardens", "sky_bridges", "wind_mills", "cloud_platforms", "rainbow_bridges",
            "angelic_statues", "divine_altars", "celestial_observatories", "sky_libraries", "cloud_cities",
            "wind_temples", "aerial_transportation", "gravity_defying_structures", "floating_water_features",
            "sky_menageries", "cloud_farms", "wind_harvesters", "atmospheric_processors", "celestial_navigators",
            "divine_messengers", "sky_guardians", "cloud_shepherds", "wind_dancers", "celestial_architects"
        },
        proceduralElements = {
            terrainComplexity = 0.7,
            structuralVariation = 1.0,
            decorativeAbundance = 0.8,
            elementalIntensity = 0.8,
            weatherIntensity = 0.7,
            hazardDensity = 0.5,
            secretAreas = 6,
            hiddenPassages = 7,
            emergentGameplay = true,
            gravitationalFields = true,
            atmosphericDynamics = true
        },
        environmentalHazards = {
            "WIND_SHEAR", "GRAVITY_WELLS", "LIGHTNING_STRIKES", "CLOUD_BURSTS", "ATMOSPHERIC_PRESSURE",
            "WIND_TUNNELS", "GRAVITY_REVERSALS", "STORM_SYSTEMS", "TURBULENCE", "ALTITUDE_SICKNESS",
            "COSMIC_RADIATION", "ELECTROMAGNETIC_INTERFERENCE", "SOLAR_FLARES", "METEOR_SHOWERS", "SPACE_DEBRIS"
        },
        interactiveElements = {
            "WIND_MANIPULATION", "GRAVITY_CONTROL", "CLOUD_SHAPING", "ATMOSPHERIC_NAVIGATION", "CELESTIAL_ALIGNMENT",
            "SKY_WRITING", "WEATHER_SUMMONING", "FLIGHT_MASTERY", "DIVINE_COMMUNICATION", "COSMIC_AWARENESS",
            "ETHEREAL_CONSTRUCTION", "HEAVENLY_PROPHECY", "AERIAL_ACROBATICS", "WIND_WALKING", "CLOUD_RIDING"
        },
        dynamicEvents = {
            "CELESTIAL_CONVERGENCE", "DIVINE_INTERVENTION", "COSMIC_STORM", "HEAVENLY_ASCENSION", "WIND_APOCALYPSE",
            "GRAVITY_INVERSION", "ATMOSPHERIC_REBIRTH", "CELESTIAL_DANCE", "DIVINE_JUDGMENT", "COSMIC_HARMONY",
            "ETHEREAL_AWAKENING", "HEAVENLY_TRANSFORMATION", "WIND_REVOLUTION", "CELESTIAL_ENLIGHTENMENT",
            "DIVINE_TRANSCENDENCE"
        }
    },
    
    UNDERWATER_ABYSS = {
        name = "Abyssal Depths",
        size = Vector3.new(150, 20, 150),
        spawnHeight = -200,
        difficulty = "EXTREME",
        biome = "OCEANIC",
        weatherPattern = "UNDERWATER_CURRENTS",
        timeOfDay = "ETERNAL_DARKNESS",
        geologicalFormation = "OCEANIC_TRENCH",
        architecturalStyle = "AQUATIC",
        culturalInfluence = "ATLANTEAN",
        historicalPeriod = "ANTEDILUVIAN",
        mysticalElements = true,
        elementalForces = {"WATER", "PRESSURE", "DARKNESS", "BIOELECTRICITY"},
        marineEcosystems = {"DEEP_SEA", "THERMAL_VENTS", "KELP_FORESTS", "CORAL_REEFS"},
        theme = {
            primaryColor = Color3.fromRGB(0, 50, 100),
            secondaryColor = Color3.fromRGB(0, 100, 150),
            accentColor = Color3.fromRGB(0, 255, 255),
            oceanColors = {
                Color3.fromRGB(0, 20, 40),    -- Deep Ocean
                Color3.fromRGB(0, 40, 80),    -- Deep Blue
                Color3.fromRGB(0, 60, 120),   -- Ocean Blue
                Color3.fromRGB(0, 80, 160),   -- Sea Blue
                Color3.fromRGB(100, 200, 255) -- Light Aqua
            },
            shadowColor = Color3.fromRGB(0, 10, 20),
            highlightColor = Color3.fromRGB(200, 255, 255),
            material = Enum.Material.Glass,
            alternativeMaterials = {Enum.Material.Ice, Enum.Material.ForceField, Enum.Material.Neon}
        },
        lighting = {
            ambient = Color3.fromRGB(0, 50, 100),
            brightness = 0.5,
            clockTime = 0,
            fogEnd = 50,
            fogColor = Color3.fromRGB(0, 30, 60),
            shadows = true,
            volumetricLighting = true,
            bioluminescence = true,
            underwaterEffects = true,
            ambientOcclusion = 0.9,
            bloomIntensity = 0.7,
            contrast = 1.3,
            saturation = 0.7,
            causticsEffects = true,
            phosphorescence = 0.8
        },
        acoustics = {
            reverbType = "UNDERWATER",
            echoDelay = 3.0,
            resonanceFrequency = 60,
            ambientSounds = {"WHALE_SONGS", "WATER_BUBBLES", "DEEP_CURRENTS", "SONAR_PINGS"},
            musicTheme = "AMBIENT_MYSTERIOUS",
            dynamicAudioLayers = true,
            hydroacoustics = 2.0,
            sonarEffects = 1.5
        },
        decorations = {
            "coral_reefs", "kelp_forests", "thermal_vents", "bioluminescent_creatures", "underwater_ruins",
            "submarine_wrecks", "treasure_chests", "pearl_beds", "sea_anemones", "underwater_caves",
            "abyssal_plains", "volcanic_vents", "deep_sea_trenches", "pressure_domes", "aquatic_gardens",
            "underwater_cities", "submarine_bases", "oceanic_temples", "sea_monster_lairs", "atlantean_artifacts",
            "bioluminescent_forests", "underwater_geysers", "pressure_chambers", "aquatic_observatories", "sea_libraries"
        },
        proceduralElements = {
            terrainComplexity = 1.0,
            structuralVariation = 0.9,
            decorativeAbundance = 0.9,
            elementalIntensity = 1.0,
            weatherIntensity = 0.8,
            hazardDensity = 0.8,
            secretAreas = 8,
            hiddenPassages = 6,
            emergentGameplay = true,
            marineEcology = true,
            pressureDynamics = true
        },
        environmentalHazards = {
            "CRUSHING_PRESSURE", "UNDERWATER_CURRENTS", "DEEP_SEA_PREDATORS", "OXYGEN_DEPLETION", "DECOMPRESSION",
            "THERMAL_VENTS", "POISONOUS_ALGAE", "ELECTRICAL_EELS", "WHIRLPOOLS", "UNDERWATER_EARTHQUAKES",
            "TSUNAMI_WAVES", "PRESSURE_IMPLOSIONS", "BIOLUMINESCENT_TOXINS", "SONAR_INTERFERENCE", "DEPTH_MADNESS"
        },
        interactiveElements = {
            "PRESSURE_CONTROL", "WATER_MANIPULATION", "MARINE_COMMUNICATION", "UNDERWATER_NAVIGATION", "DEPTH_MASTERY",
            "AQUATIC_CONSTRUCTION", "SUBMARINE_OPERATION", "OCEANIC_PROPHECY", "DEEP_SEA_EXPLORATION", "WATER_BREATHING",
            "PRESSURE_ADAPTATION", "MARINE_SYMBIOSIS", "UNDERWATER_ARCHAEOLOGY", "OCEANIC_HARMONY", "ABYSSAL_WISDOM"
        },
        dynamicEvents = {
            "GREAT_FLOOD", "OCEANIC_UPRISING", "LEVIATHAN_AWAKENING", "ATLANTIS_RISING", "KRAKEN_EMERGENCE",
            "TSUNAMI_APOCALYPSE", "DEEP_SEA_CONVERGENCE", "OCEANIC_CONSCIOUSNESS", "MARINE_EVOLUTION", "WATER_ASCENSION",
            "ABYSSAL_REVELATION", "OCEANIC_TRANSCENDENCE", "MARINE_ENLIGHTENMENT", "AQUATIC_TRANSFORMATION", "SEA_REBIRTH"
        }
    },
    
    SPACE_STATION = {
        name = "Orbital Combat Deck",
        size = Vector3.new(100, 8, 100),
        spawnHeight = 1000,
        difficulty = "EXTREME",
        biome = "SPACE",
        weatherPattern = "SOLAR_WIND",
        timeOfDay = "COSMIC",
        geologicalFormation = "ARTIFICIAL_SATELLITE",
        architecturalStyle = "SPACE_AGE",
        culturalInfluence = "GALACTIC",
        historicalPeriod = "FUTURE",
        mysticalElements = false,
        technologicalLevel = "ULTRA_ADVANCED",
        spaceEnvironment = {"ZERO_GRAVITY", "VACUUM", "RADIATION", "MICROMETEORS"},
        galacticSectors = {"MILKY_WAY", "ANDROMEDA", "ALPHA_CENTAURI", "PROXIMA"},
        theme = {
            primaryColor = Color3.fromRGB(80, 80, 80),
            secondaryColor = Color3.fromRGB(120, 120, 120),
            accentColor = Color3.fromRGB(0, 150, 255),
            spaceColors = {
                Color3.fromRGB(0, 0, 0),      -- Deep Space
                Color3.fromRGB(25, 25, 112),  -- Midnight Blue
                Color3.fromRGB(72, 61, 139),  -- Dark Slate Blue
                Color3.fromRGB(123, 104, 238), -- Medium Slate Blue
                Color3.fromRGB(255, 255, 255) -- Starlight
            },
            shadowColor = Color3.fromRGB(20, 20, 20),
            highlightColor = Color3.fromRGB(255, 255, 255),
            material = Enum.Material.Metal,
            alternativeMaterials = {Enum.Material.Plastic, Enum.Material.Glass, Enum.Material.Neon}
        },
        lighting = {
            ambient = Color3.fromRGB(50, 50, 100),
            brightness = 1.5,
            clockTime = 0,
            fogEnd = 2000,
            fogColor = Color3.fromRGB(0, 0, 50),
            shadows = true,
            volumetricLighting = true,
            cosmicRadiation = true,
            starfield = true,
            ambientOcclusion = 0.7,
            bloomIntensity = 0.5,
            contrast = 1.2,
            saturation = 0.8,
            spacialDistortion = 0.2,
            quantumEffects = 0.3
        },
        acoustics = {
            reverbType = "SPACE_VOID",
            echoDelay = 0.1,
            resonanceFrequency = 1000,
            ambientSounds = {"SPACE_SILENCE", "MECHANICAL_HUM", "SOLAR_WIND", "COSMIC_BACKGROUND"},
            musicTheme = "EPIC_SPACE",
            dynamicAudioLayers = true,
            vacuumEffects = true,
            cosmicResonance = 0.5
        },
        decorations = {
            "space_stations", "satellite_arrays", "solar_panels", "asteroid_fields", "starship_docks",
            "observation_decks", "zero_gravity_chambers", "artificial_gravity_generators", "cosmic_observatories",
            "space_gardens", "hydroponics_bays", "crew_quarters", "command_centers", "engineering_sections",
            "medical_bays", "recreational_facilities", "cargo_holds", "shuttle_bays", "communication_arrays",
            "defense_systems", "energy_collectors", "particle_accelerators", "quantum_computers", "teleportation_hubs"
        },
        proceduralElements = {
            terrainComplexity = 0.5,
            structuralVariation = 1.0,
            decorativeAbundance = 0.8,
            technologicalIntensity = 1.0,
            weatherIntensity = 0.6,
            hazardDensity = 0.7,
            secretAreas = 10,
            hiddenPassages = 8,
            emergentGameplay = true,
            gravitationalFields = true,
            quantumMechanics = true
        },
        environmentalHazards = {
            "ZERO_GRAVITY", "VACUUM_EXPOSURE", "COSMIC_RADIATION", "METEOR_SHOWERS", "SOLAR_FLARES",
            "SYSTEM_FAILURES", "HULL_BREACHES", "DECOMPRESSION", "ELECTROMAGNETIC_STORMS", "ALIEN_ENCOUNTERS",
            "SPACE_DEBRIS", "GRAVITATIONAL_ANOMALIES", "QUANTUM_FLUCTUATIONS", "WORMHOLE_INSTABILITIES", "TIME_DILATION"
        },
        interactiveElements = {
            "GRAVITY_CONTROL", "LIFE_SUPPORT_SYSTEMS", "NAVIGATION_CONTROL", "COMMUNICATION_ARRAYS", "DEFENSE_SYSTEMS",
            "ENERGY_MANAGEMENT", "ARTIFICIAL_INTELLIGENCE", "QUANTUM_COMPUTING", "TELEPORTATION_TECHNOLOGY", "TIME_MANIPULATION",
            "DIMENSIONAL_PORTALS", "COSMIC_COMMUNICATION", "GALACTIC_NAVIGATION", "SPACE_CONSTRUCTION", "STELLAR_ENGINEERING"
        },
        dynamicEvents = {
            "ALIEN_INVASION", "SUPERNOVA_EXPLOSION", "BLACK_HOLE_FORMATION", "GALACTIC_WAR", "COSMIC_CONVERGENCE",
            "DIMENSIONAL_RIFT", "TIME_PARADOX", "QUANTUM_ENTANGLEMENT", "STELLAR_COLLAPSE", "GALACTIC_ALIGNMENT",
            "COSMIC_CONSCIOUSNESS", "UNIVERSAL_TRANSCENDENCE", "GALACTIC_EVOLUTION", "COSMIC_ENLIGHTENMENT", "UNIVERSAL_HARMONY"
        }
    }
}

-- Advanced mathematical functions for procedural generation
local function generatePerlinNoise(x, z, scale, seed)
    local function fade(t)
        return t * t * t * (t * (t * 6 - 15) + 10)
    end
    
    local function lerp(a, b, t)
        return a + t * (b - a)
    end
    
    local function grad(hash, x, z)
        local h = hash % 16
        local u = h < 8 and x or z
        local v = h < 4 and z or (h == 12 or h == 14) and x or 0
        return ((h % 2) == 0 and u or -u) + ((h % 4) < 2 and v or -v)
    end
    
    x = x * scale
    z = z * scale
    
    local xi = math.floor(x) % 256
    local zi = math.floor(z) % 256
    local xf = x - math.floor(x)
    local zf = z - math.floor(z)
    
    local u = fade(xf)
    local v = fade(zf)
    
    local p = {}
    for i = 0, 511 do
        p[i] = (seed * i * 15731 + 789221) % 256
    end
    
    local aa = p[p[xi] + zi]
    local ab = p[p[xi] + zi + 1]
    local ba = p[p[xi + 1] + zi]
    local bb = p[p[xi + 1] + zi + 1]
    
    local x1 = lerp(grad(aa, xf, zf), grad(ba, xf - 1, zf), u)
    local x2 = lerp(grad(ab, xf, zf - 1), grad(bb, xf - 1, zf - 1), u)
    
    return lerp(x1, x2, v)
end

local function generateFractalNoise(x, z, octaves, persistence, scale, seed)
    local value = 0
    local amplitude = 1
    local frequency = scale
    
    for i = 1, octaves do
        value = value + generatePerlinNoise(x * frequency, z * frequency, 1, seed + i) * amplitude
        amplitude = amplitude * persistence
        frequency = frequency * 2
    end
    
    return value
end

local function calculateFibonacciSpiral(index, radius)
    local angle = index * 2.39996323 -- Golden angle in radians
    local distance = radius * math.sqrt(index)
    return Vector3.new(math.cos(angle) * distance, 0, math.sin(angle) * distance)
end

local function generateVoronoiPattern(x, z, cellSize, seed)
    local cellX = math.floor(x / cellSize)
    local cellZ = math.floor(z / cellSize)
    local minDist = math.huge
    
    for i = -1, 1 do
        for j = -1, 1 do
            local neighborX = cellX + i
            local neighborZ = cellZ + j
            local pointX = (neighborX + 0.5 + math.sin(neighborX * seed + neighborZ * seed * 2) * 0.4) * cellSize
            local pointZ = (neighborZ + 0.5 + math.cos(neighborX * seed * 3 + neighborZ * seed) * 0.4) * cellSize
            local dist = math.sqrt((x - pointX)^2 + (z - pointZ)^2)
            minDist = math.min(minDist, dist)
        end
    end
    
    return minDist / cellSize
end

-- Advanced terrain generation system
local function generateProceduralTerrain(arenaData, platform, complexity)
    local size = arenaData.size
    local position = platform.Position
    local terrainFeatures = {}
    
    -- Generate height map using multiple noise layers
    local function getTerrainHeight(x, z)
        local baseHeight = generateFractalNoise(x, z, 4, 0.5, 0.01, PERLIN_NOISE_SEEDS.TERRAIN)
        local detailHeight = generateFractalNoise(x, z, 6, 0.3, 0.05, PERLIN_NOISE_SEEDS.TERRAIN + 1000)
        local microHeight = generateFractalNoise(x, z, 8, 0.1, 0.2, PERLIN_NOISE_SEEDS.TERRAIN + 2000)
        
        return (baseHeight * 20 + detailHeight * 8 + microHeight * 2) * complexity
    end
    
    -- Generate terrain chunks
    local chunkSize = 10
    local chunksPerSide = math.ceil(size.X / chunkSize)
    
    for chunkX = 1, chunksPerSide do
        for chunkZ = 1, chunksPerSide do
            local chunkWorldX = position.X - size.X/2 + (chunkX - 1) * chunkSize
            local chunkWorldZ = position.Z - size.Z/2 + (chunkZ - 1) * chunkSize
            
            local avgHeight = getTerrainHeight(chunkWorldX, chunkWorldZ)
            
            if math.abs(avgHeight) > 2 then -- Only create significant terrain features
                local terrainChunk = Instance.new("Part")
                terrainChunk.Name = "TerrainChunk_" .. chunkX .. "_" .. chunkZ
                terrainChunk.Size = Vector3.new(chunkSize, math.abs(avgHeight), chunkSize)
                terrainChunk.Position = Vector3.new(
                    chunkWorldX + chunkSize/2,
                    position.Y + size.Y/2 + avgHeight/2,
                    chunkWorldZ + chunkSize/2
                )
                terrainChunk.Anchored = true
                terrainChunk.Material = arenaData.theme.material
                terrainChunk.BrickColor = BrickColor.new(arenaData.theme.primaryColor)
                terrainChunk.Parent = workspace
                
                -- Add surface details based on biome
                if arenaData.biome == "VOLCANIC" then
                    terrainChunk.Material = Enum.Material.Basalt
                    if math.random() < 0.3 then
                        local lavaPool = Instance.new("Part")
                        lavaPool.Name = "LavaDetail"
                        lavaPool.Size = Vector3.new(chunkSize * 0.8, 0.5, chunkSize * 0.8)
                        lavaPool.Position = terrainChunk.Position + Vector3.new(0, terrainChunk.Size.Y/2 + 0.25, 0)
                        lavaPool.Anchored = true
                        lavaPool.Material = Enum.Material.Neon
                        lavaPool.BrickColor = BrickColor.new(Color3.fromRGB(255, 100, 0))
                        lavaPool.Parent = workspace
                        
                        local fire = Instance.new("Fire")
                        fire.Size = 5
                        fire.Heat = 10
                        fire.Parent = lavaPool
                    end
                elseif arenaData.biome == "ARCTIC" then
                    terrainChunk.Material = Enum.Material.Ice
                    terrainChunk.Transparency = 0.2
                    if math.random() < 0.4 then
                        local snowDrift = Instance.new("Part")
                        snowDrift.Name = "SnowDetail"
                        snowDrift.Size = Vector3.new(chunkSize * 0.6, 1, chunkSize * 0.6)
                        snowDrift.Position = terrainChunk.Position + Vector3.new(0, terrainChunk.Size.Y/2 + 0.5, 0)
                        snowDrift.Anchored = true
                        snowDrift.Material = Enum.Material.Snow
                        snowDrift.BrickColor = BrickColor.new(Color3.fromRGB(255, 255, 255))
                        snowDrift.Parent = workspace
                    end
                elseif arenaData.biome == "DESERT" then
                    if math.random() < 0.2 then
                        local sandDune = Instance.new("Part")
                        sandDune.Name = "SandDetail"
                        sandDune.Size = Vector3.new(chunkSize * 1.2, avgHeight * 0.3, chunkSize * 1.2)
                        sandDune.Position = terrainChunk.Position + Vector3.new(
                            math.random(-3, 3),
                            terrainChunk.Size.Y/2 + sandDune.Size.Y/2,
                            math.random(-3, 3)
                        )
                        sandDune.Anchored = true
                        sandDune.Material = Enum.Material.Sand
                        sandDune.BrickColor = BrickColor.new(Color3.fromRGB(238, 203, 173))
                        sandDune.Shape = Enum.PartType.Ball
                        sandDune.Parent = workspace
                    end
                end
                
                table.insert(terrainFeatures, terrainChunk)
            end
        end
    end
    
    return terrainFeatures
end

-- Advanced weather and atmospheric system
local function createAtmosphericEffects(arenaData, platform)
    local atmosphericElements = {}
    local size = arenaData.size
    local position = platform.Position
    
    -- Create particle systems based on weather pattern
    if arenaData.weatherPattern == "SANDSTORM" then
        local sandstormEmitter = Instance.new("Attachment")
        sandstormEmitter.Name = "SandstormEmitter"
        sandstormEmitter.Position = position + Vector3.new(0, size.Y/2 + 50, 0)
        sandstormEmitter.Parent = platform
        
        local sandParticles = Instance.new("ParticleEmitter")
        sandParticles.Name = "SandParticles"
        sandParticles.Texture = "rbxasset://textures/particles/smoke_main.dds"
        sandParticles.Lifetime = NumberRange.new(8, 12)
        sandParticles.Rate = 200
        sandParticles.SpreadAngle = Vector2.new(45, 45)
        sandParticles.Speed = NumberRange.new(10, 25)
        sandParticles.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(238, 203, 173)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(205, 175, 149)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(139, 119, 101))
        }
        sandParticles.Size = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.3, 2),
            NumberSequenceKeypoint.new(1, 0)
        }
        sandParticles.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.8),
            NumberSequenceKeypoint.new(0.5, 0.5),
            NumberSequenceKeypoint.new(1, 1)
        }
        sandParticles.Parent = sandstormEmitter
        
        table.insert(atmosphericElements, sandstormEmitter)
        
    elseif arenaData.weatherPattern == "ELECTRIC_STORM" then
        local stormCenter = Instance.new("Attachment")
        stormCenter.Name = "ElectricStormCenter"
        stormCenter.Position = position + Vector3.new(0, size.Y/2 + 30, 0)
        stormCenter.Parent = platform
        
        local electricParticles = Instance.new("ParticleEmitter")
        electricParticles.Name = "ElectricParticles"
        electricParticles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        electricParticles.Lifetime = NumberRange.new(1, 3)
        electricParticles.Rate = 50
        electricParticles.SpreadAngle = Vector2.new(180, 180)
        electricParticles.Speed = NumberRange.new(5, 15)
        electricParticles.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 255))
        }
        electricParticles.Size = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(0.5, 1),
            NumberSequenceKeypoint.new(1, 0)
        }
        electricParticles.Parent = stormCenter
        
        -- Create lightning bolts
        spawn(function()
            while true do
                wait(math.random(3, 8))
                
                local lightningBolt = Instance.new("Part")
                lightningBolt.Name = "LightningBolt"
                lightningBolt.Size = Vector3.new(1, 100, 1)
                lightningBolt.Position = position + Vector3.new(
                    math.random(-size.X/2, size.X/2),
                    size.Y/2 + 50,
                    math.random(-size.Z/2, size.Z/2)
                )
                lightningBolt.Anchored = true
                lightningBolt.CanCollide = false
                lightningBolt.Material = Enum.Material.Neon
                lightningBolt.BrickColor = BrickColor.new(Color3.fromRGB(255, 255, 255))
                lightningBolt.Parent = workspace
                
                local lightningSound = Instance.new("Sound")
                lightningSound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
                lightningSound.Volume = 0.5
                lightningSound.Parent = lightningBolt
                lightningSound:Play()
                
                wait(0.1)
                lightningBolt:Destroy()
            end
        end)
        
        table.insert(atmosphericElements, stormCenter)
        
    elseif arenaData.weatherPattern == "BLIZZARD" then
        local blizzardEmitter = Instance.new("Attachment")
        blizzardEmitter.Name = "BlizzardEmitter"
        blizzardEmitter.Position = position + Vector3.new(0, size.Y/2 + 40, 0)
        blizzardEmitter.Parent = platform
        
        local snowParticles = Instance.new("ParticleEmitter")
        snowParticles.Name = "SnowParticles"
        snowParticles.Texture = "rbxasset://textures/particles/snow_main.dds"
        snowParticles.Lifetime = NumberRange.new(10, 15)
        snowParticles.Rate = 300
        snowParticles.SpreadAngle = Vector2.new(30, 30)
        snowParticles.Speed = NumberRange.new(5, 20)
        snowParticles.Acceleration = Vector3.new(5, -10, 0) -- Wind effect
        snowParticles.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        snowParticles.Size = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(0.5, 0.5),
            NumberSequenceKeypoint.new(1, 0.1)
        }
        snowParticles.Parent = blizzardEmitter
        
        table.insert(atmosphericElements, blizzardEmitter)
    end
    
    return atmosphericElements
end

-- Advanced structural generation system
local function generateComplexStructures(arenaData, platform)
    local structures = {}
    local size = arenaData.size
    local position = platform.Position
    
    if arenaData.architecturalStyle == "MESOPOTAMIAN" then
        -- Generate ziggurat-style structures
        local zigguratLevels = math.random(3, 7)
        for level = 1, zigguratLevels do
            local levelSize = size.X * (0.8 - (level - 1) * 0.15)
            local levelHeight = 5
            local levelY = position.Y + size.Y/2 + (level - 1) * levelHeight + levelHeight/2
            
            local zigguratLevel = Instance.new("Part")
            zigguratLevel.Name = "ZigguratLevel_" .. level
            zigguratLevel.Size = Vector3.new(levelSize, levelHeight, levelSize)
            zigguratLevel.Position = Vector3.new(position.X, levelY, position.Z)
            zigguratLevel.Anchored = true
            zigguratLevel.Material = Enum.Material.Sandstone
            zigguratLevel.BrickColor = BrickColor.new(arenaData.theme.primaryColor)
            zigguratLevel.Parent = workspace
            
            -- Add stairs
            if level < zigguratLevels then
                local stairWidth = 8
                local stairCount = 10
                for i = 1, stairCount do
                    local stair = Instance.new("Part")
                    stair.Name = "Stair_" .. level .. "_" .. i
                    stair.Size = Vector3.new(stairWidth, 0.5, 2)
                    stair.Position = Vector3.new(
                        position.X,
                        levelY + levelHeight/2 + i * 0.5,
                        position.Z + levelSize/2 - i * 2
                    )
                    stair.Anchored = true
                    stair.Material = arenaData.theme.material
                    stair.BrickColor = BrickColor.new(arenaData.theme.accentColor)
                    stair.Parent = workspace
                    table.insert(structures, stair)
                end
            end
            
            table.insert(structures, zigguratLevel)
        end
        
    elseif arenaData.architecturalStyle == "FUTURISTIC" then
        -- Generate holographic structures
        local holoCount = math.random(5, 12)
        for i = 1, holoCount do
            local angle = (i - 1) * (math.pi * 2 / holoCount)
            local distance = size.X * 0.3
            local holoHeight = math.random(10, 25)
            
            local holoStructure = Instance.new("Part")
            holoStructure.Name = "HoloStructure_" .. i
            holoStructure.Size = Vector3.new(3, holoHeight, 3)
            holoStructure.Position = position + Vector3.new(
                math.cos(angle) * distance,
                size.Y/2 + holoHeight/2,
                math.sin(angle) * distance
            )
            holoStructure.Anchored = true
            holoStructure.Material = Enum.Material.ForceField
            holoStructure.BrickColor = BrickColor.new(arenaData.theme.accentColor)
            holoStructure.Transparency = 0.3
            holoStructure.Parent = workspace
            
            -- Add holographic effects
            local holoLight = Instance.new("PointLight")
            holoLight.Color = arenaData.theme.accentColor
            holoLight.Brightness = 2
            holoLight.Range = 15
            holoLight.Parent = holoStructure
            
            -- Add floating animation
            local floatTween = TweenService:Create(
                holoStructure,
                TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                {Position = holoStructure.Position + Vector3.new(0, 3, 0)}
            )
            floatTween:Play()
            
            table.insert(structures, holoStructure)
        end
        
    elseif arenaData.architecturalStyle == "CRYSTALLINE" then
        -- Generate crystal formations
        local crystalCount = math.random(8, 15)
        for i = 1, crystalCount do
            local crystalSize = Vector3.new(
                math.random(2, 8),
                math.random(8, 20),
                math.random(2, 8)
            )
            local angle = math.random() * math.pi * 2
            local distance = math.random(15, size.X/2.5)
            
            local crystal = Instance.new("Part")
            crystal.Name = "Crystal_" .. i
            crystal.Size = crystalSize
            crystal.Position = position + Vector3.new(
                math.cos(angle) * distance,
                size.Y/2 + crystalSize.Y/2,
                math.sin(angle) * distance
            )
            crystal.Anchored = true
            crystal.Material = Enum.Material.Ice
            crystal.BrickColor = BrickColor.new(arenaData.theme.primaryColor)
            crystal.Transparency = 0.2
            crystal.Shape = Enum.PartType.Wedge
            crystal.Rotation = Vector3.new(
                math.random(-15, 15),
                math.random(0, 360),
                math.random(-15, 15)
            )
            crystal.Parent = workspace
            
            -- Add crystal resonance effects
            local crystalSound = Instance.new("Sound")
            crystalSound.SoundId = "rbxasset://sounds/impact_generic.mp3"
            crystalSound.Volume = 0.1
            crystalSound.Pitch = 1.5 + math.random() * 0.5
            crystalSound.Parent = crystal
            
            spawn(function()
                while crystal.Parent do
                    wait(math.random(10, 30))
                    crystalSound:Play()
                end
            end)
            
            table.insert(structures, crystal)
        end
    end
    
    return structures
end

-- Generate main arena platform
function ArenaGenerator.createArenaPlatform(arenaData, position)
    local platform = Instance.new("Part")
    platform.Name = "ArenaPlatform"
    platform.Size = arenaData.size
    platform.Position = position
    platform.Anchored = true
    platform.Material = arenaData.theme.material
    platform.BrickColor = BrickColor.new(arenaData.theme.primaryColor)
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Parent = workspace
    
    -- Add platform details with procedural texturing
    local decal = Instance.new("Decal")
    decal.Texture = "rbxasset://textures/face.png" -- Replace with arena-specific texture
    decal.Face = Enum.NormalId.Top
    decal.Parent = platform
    
    -- Add complex geometric patterns based on cultural influence
    if arenaData.culturalInfluence == "BABYLONIAN" then
        -- Create cuneiform-style markings
        local cuneiformPattern = Instance.new("SurfaceGui")
        cuneiformPattern.Name = "CuneiformPattern"
        cuneiformPattern.Face = Enum.NormalId.Top
        cuneiformPattern.Parent = platform
        
        for i = 1, 20 do
            local cuneiformSymbol = Instance.new("ImageLabel")
            cuneiformSymbol.Name = "Symbol_" .. i
            cuneiformSymbol.Size = UDim2.new(0, 50, 0, 50)
            cuneiformSymbol.Position = UDim2.new(
                math.random(0, 80) / 100,
                0,
                math.random(0, 80) / 100,
                0
            )
            cuneiformSymbol.BackgroundTransparency = 1
            cuneiformSymbol.ImageTransparency = 0.3
            cuneiformSymbol.ImageColor3 = arenaData.theme.accentColor
            cuneiformSymbol.Parent = cuneiformPattern
        end
        
    elseif arenaData.culturalInfluence == "CYBERPUNK" then
        -- Create digital circuit patterns
        local circuitPattern = Instance.new("SurfaceGui")
        circuitPattern.Name = "CircuitPattern"
        circuitPattern.Face = Enum.NormalId.Top
        circuitPattern.Parent = platform
        
        -- Generate circuit board layout
        for i = 1, 50 do
            local circuitLine = Instance.new("Frame")
            circuitLine.Name = "CircuitLine_" .. i
            circuitLine.Size = UDim2.new(0, math.random(20, 200), 0, 2)
            circuitLine.Position = UDim2.new(
                math.random(0, 80) / 100,
                0,
                math.random(0, 80) / 100,
                0
            )
            circuitLine.BackgroundColor3 = arenaData.theme.neonColors[math.random(1, #arenaData.theme.neonColors)]
            circuitLine.BorderSizePixel = 0
            circuitLine.Parent = circuitPattern
            
            -- Add glowing effect
            local glow = Instance.new("ImageLabel")
            glow.Name = "Glow"
            glow.Size = UDim2.new(1, 10, 1, 10)
            glow.Position = UDim2.new(0, -5, 0, -5)
            glow.BackgroundTransparency = 1
            glow.ImageTransparency = 0.5
            glow.Parent = circuitLine
        end
        
    elseif arenaData.culturalInfluence == "NORDIC" then
        -- Create runic inscriptions
        local runicPattern = Instance.new("SurfaceGui")
        runicPattern.Name = "RunicPattern"
        runicPattern.Face = Enum.NormalId.Top
        runicPattern.Parent = platform
        
        local runicAlphabet = {"ᚠ", "ᚢ", "ᚦ", "ᚨ", "ᚱ", "ᚲ", "ᚷ", "ᚹ", "ᚺ", "ᚾ", "ᛁ", "ᛃ", "ᛇ", "ᛈ", "ᛉ", "ᛊ"}
        
        for i = 1, 30 do
            local runicSymbol = Instance.new("TextLabel")
            runicSymbol.Name = "Rune_" .. i
            runicSymbol.Size = UDim2.new(0, 40, 0, 40)
            runicSymbol.Position = UDim2.new(
                math.random(5, 85) / 100,
                0,
                math.random(5, 85) / 100,
                0
            )
            runicSymbol.BackgroundTransparency = 1
            runicSymbol.Text = runicAlphabet[math.random(1, #runicAlphabet)]
            runicSymbol.TextColor3 = arenaData.theme.accentColor
            runicSymbol.TextScaled = true
            runicSymbol.Font = Enum.Font.Antique
            runicSymbol.Parent = runicPattern
        end
    end
    
    -- Add environmental foundations
    if arenaData.biome == "VOLCANIC" then
        local magmaVeins = Instance.new("Part")
        magmaVeins.Name = "MagmaVeins"
        magmaVeins.Size = arenaData.size + Vector3.new(0, 1, 0)
        magmaVeins.Position = position + Vector3.new(0, -0.5, 0)
        magmaVeins.Anchored = true
        magmaVeins.Material = Enum.Material.Neon
        magmaVeins.BrickColor = BrickColor.new(Color3.fromRGB(255, 100, 0))
        magmaVeins.Transparency = 0.3
        magmaVeins.Parent = workspace
        
        -- Add pulsing glow effect
        local glowTween = TweenService:Create(
            magmaVeins,
            TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {Transparency = 0.7}
        )
        glowTween:Play()
        
    elseif arenaData.biome == "ARCTIC" then
        local permafrost = Instance.new("Part")
        permafrost.Name = "Permafrost"
        permafrost.Size = arenaData.size + Vector3.new(10, 5, 10)
        permafrost.Position = position + Vector3.new(0, -2.5, 0)
        permafrost.Anchored = true
        permafrost.Material = Enum.Material.Ice
        permafrost.BrickColor = BrickColor.new(Color3.fromRGB(200, 230, 255))
        permafrost.Transparency = 0.4
        permafrost.Parent = workspace
        
    elseif arenaData.biome == "OCEANIC" then
        local seaFloor = Instance.new("Part")
        seaFloor.Name = "SeaFloor"
        seaFloor.Size = arenaData.size + Vector3.new(20, 3, 20)
        seaFloor.Position = position + Vector3.new(0, -1.5, 0)
        seaFloor.Anchored = true
        seaFloor.Material = Enum.Material.Sand
        seaFloor.BrickColor = BrickColor.new(Color3.fromRGB(139, 119, 101))
        seaFloor.Parent = workspace
        
        -- Add coral formations
        for i = 1, 15 do
            local coral = Instance.new("Part")
            coral.Name = "Coral_" .. i
            coral.Size = Vector3.new(
                math.random(2, 6),
                math.random(3, 8),
                math.random(2, 6)
            )
            coral.Position = position + Vector3.new(
                math.random(-arenaData.size.X/2, arenaData.size.X/2),
                arenaData.size.Y/2 + coral.Size.Y/2,
                math.random(-arenaData.size.Z/2, arenaData.size.Z/2)
            )
            coral.Anchored = true
            coral.Material = Enum.Material.Cobblestone
            coral.BrickColor = BrickColor.new(Color3.fromRGB(255, 127, 80))
            coral.Shape = Enum.PartType.Block
            coral.Parent = workspace
        end
    end
    
    return platform
end

-- Create advanced boundary system with dynamic elements
function ArenaGenerator.createBoundaryWalls(platform, arenaData)
    local size = arenaData.size
    local position = platform.Position
    local wallHeight = 20 + (arenaData.difficulty == "EXTREME" and 10 or 0)
    local wallThickness = 2 + (arenaData.difficulty == "EXTREME" and 1 or 0)
    
    local walls = {}
    local wallPositions = {
        {name = "NorthWall", offset = Vector3.new(0, wallHeight/2 + size.Y/2, size.Z/2 + wallThickness/2), 
         size = Vector3.new(size.X + wallThickness * 2, wallHeight, wallThickness)},
        {name = "SouthWall", offset = Vector3.new(0, wallHeight/2 + size.Y/2, -size.Z/2 - wallThickness/2), 
         size = Vector3.new(size.X + wallThickness * 2, wallHeight, wallThickness)},
        {name = "EastWall", offset = Vector3.new(size.X/2 + wallThickness/2, wallHeight/2 + size.Y/2, 0), 
         size = Vector3.new(wallThickness, wallHeight, size.Z)},
        {name = "WestWall", offset = Vector3.new(-size.X/2 - wallThickness/2, wallHeight/2 + size.Y/2, 0), 
         size = Vector3.new(wallThickness, wallHeight, size.Z)}
    }
    
    for _, wallData in pairs(wallPositions) do
        local wall = Instance.new("Part")
        wall.Name = wallData.name
        wall.Size = wallData.size
        wall.Position = position + wallData.offset
        wall.Anchored = true
        wall.Material = arenaData.theme.material
        wall.BrickColor = BrickColor.new(arenaData.theme.primaryColor)
        wall.Parent = workspace
        
        -- Add wall decorations based on architectural style
        if arenaData.architecturalStyle == "MESOPOTAMIAN" then
            -- Add brick texture pattern
            local brickTexture = Instance.new("SurfaceGui")
            brickTexture.Name = "BrickTexture"
            brickTexture.Face = Enum.NormalId.Front
            brickTexture.Parent = wall
            
            local brickRows = math.floor(wallData.size.Y / 2)
            local brickCols = math.floor(wallData.size.X / 3)
            
            for row = 1, brickRows do
                for col = 1, brickCols do
                    local brick = Instance.new("Frame")
                    brick.Name = "Brick_" .. row .. "_" .. col
                    brick.Size = UDim2.new(0, 30, 0, 18)
                    brick.Position = UDim2.new(
                        (col - 1) / brickCols + (row % 2) * 0.05,
                        0,
                        (row - 1) / brickRows,
                        0
                    )
                    brick.BackgroundColor3 = Color3.fromRGB(
                        139 + math.random(-20, 20),
                        119 + math.random(-20, 20),
                        101 + math.random(-20, 20)
                    )
                    brick.BorderSizePixel = 1
                    brick.BorderColor3 = Color3.fromRGB(100, 80, 60)
                    brick.Parent = brickTexture
                end
            end
            
        elseif arenaData.architecturalStyle == "FUTURISTIC" then
            -- Add holographic panels
            wall.Material = Enum.Material.Glass
            wall.Transparency = 0.3
            
            local holoPanel = Instance.new("SurfaceGui")
            holoPanel.Name = "HolographicPanel"
            holoPanel.Face = Enum.NormalId.Front
            holoPanel.Parent = wall
            
            for i = 1, 8 do
                local holoStrip = Instance.new("Frame")
                holoStrip.Name = "HoloStrip_" .. i
                holoStrip.Size = UDim2.new(1, 0, 0, 3)
                holoStrip.Position = UDim2.new(0, 0, i/10, 0)
                holoStrip.BackgroundColor3 = arenaData.theme.accentColor
                holoStrip.BorderSizePixel = 0
                holoStrip.Parent = holoPanel
                
                -- Add scanning animation
                local scanTween = TweenService:Create(
                    holoStrip,
                    TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
                    {BackgroundTransparency = 0.8}
                )
                scanTween:Play()
            end
            
        elseif arenaData.architecturalStyle == "CRYSTALLINE" then
            -- Add crystalline formations
            wall.Material = Enum.Material.Ice
            wall.Transparency = 0.2
            
            for i = 1, 6 do
                local crystalFormation = Instance.new("Part")
                crystalFormation.Name = "CrystalFormation_" .. i
                crystalFormation.Size = Vector3.new(2, 4, 1)
                crystalFormation.Position = wall.Position + Vector3.new(
                    math.random(-wallData.size.X/4, wallData.size.X/4),
                    math.random(-wallHeight/4, wallHeight/4),
                    wallThickness/2 + 0.5
                )
                crystalFormation.Anchored = true
                crystalFormation.Material = Enum.Material.Ice
                crystalFormation.BrickColor = BrickColor.new(arenaData.theme.accentColor)
                crystalFormation.Transparency = 0.1
                crystalFormation.Shape = Enum.PartType.Wedge
                crystalFormation.Rotation = Vector3.new(
                    math.random(-30, 30),
                    math.random(0, 360),
                    math.random(-30, 30)
                )
                crystalFormation.Parent = workspace
            end
        end
        
        -- Add interactive wall elements
        if arenaData.interactiveElements and #arenaData.interactiveElements > 0 then
            local elementType = arenaData.interactiveElements[math.random(1, #arenaData.interactiveElements)]
            
            if elementType == "LEVER_MECHANISMS" then
                local lever = Instance.new("Part")
                lever.Name = "WallLever_" .. wallData.name
                lever.Size = Vector3.new(1, 3, 0.5)
                lever.Position = wall.Position + Vector3.new(0, 0, wallThickness/2 + 0.25)
                lever.Anchored = true
                lever.Material = Enum.Material.Metal
                lever.BrickColor = BrickColor.new(Color3.fromRGB(100, 100, 100))
                lever.Parent = workspace
                
                local leverHandle = Instance.new("Part")
                leverHandle.Name = "LeverHandle"
                leverHandle.Size = Vector3.new(0.3, 1, 0.3)
                leverHandle.Position = lever.Position + Vector3.new(0, 1.5, 0)
                leverHandle.Anchored = false
                leverHandle.Material = Enum.Material.Wood
                leverHandle.BrickColor = BrickColor.new(Color3.fromRGB(139, 69, 19))
                leverHandle.Parent = workspace
                
                local leverJoint = Instance.new("HingeConstraint")
                leverJoint.Attachment0 = Instance.new("Attachment", lever)
                leverJoint.Attachment1 = Instance.new("Attachment", leverHandle)
                leverJoint.LimitsEnabled = true
                leverJoint.LowerAngle = -45
                leverJoint.UpperAngle = 45
                leverJoint.Parent = lever
                
            elseif elementType == "ANCIENT_SWITCHES" then
                local ancientSwitch = Instance.new("Part")
                ancientSwitch.Name = "AncientSwitch_" .. wallData.name
                ancientSwitch.Size = Vector3.new(2, 2, 0.5)
                ancientSwitch.Position = wall.Position + Vector3.new(0, 0, wallThickness/2 + 0.25)
                ancientSwitch.Anchored = true
                ancientSwitch.Material = Enum.Material.Sandstone
                ancientSwitch.BrickColor = BrickColor.new(arenaData.theme.accentColor)
                ancientSwitch.Parent = workspace
                
                -- Add runic inscription
                local runeGui = Instance.new("SurfaceGui")
                runeGui.Face = Enum.NormalId.Front
                runeGui.Parent = ancientSwitch
                
                local runeText = Instance.new("TextLabel")
                runeText.Size = UDim2.new(1, 0, 1, 0)
                runeText.BackgroundTransparency = 1
                runeText.Text = "⚡"
                runeText.TextColor3 = Color3.fromRGB(255, 215, 0)
                runeText.TextScaled = true
                runeText.Font = Enum.Font.Antique
                runeText.Parent = runeGui
                
            elseif elementType == "TERMINAL_HACKING" then
                local hackingTerminal = Instance.new("Part")
                hackingTerminal.Name = "HackingTerminal_" .. wallData.name
                hackingTerminal.Size = Vector3.new(3, 2, 0.3)
                hackingTerminal.Position = wall.Position + Vector3.new(0, 0, wallThickness/2 + 0.15)
                hackingTerminal.Anchored = true
                hackingTerminal.Material = Enum.Material.Metal
                hackingTerminal.BrickColor = BrickColor.new(Color3.fromRGB(40, 40, 60))
                hackingTerminal.Parent = workspace
                
                -- Add terminal screen
                local screenGui = Instance.new("SurfaceGui")
                screenGui.Face = Enum.NormalId.Front
                screenGui.Parent = hackingTerminal
                
                local screen = Instance.new("Frame")
                screen.Size = UDim2.new(0.8, 0, 0.8, 0)
                screen.Position = UDim2.new(0.1, 0, 0.1, 0)
                screen.BackgroundColor3 = Color3.fromRGB(0, 20, 0)
                screen.BorderSizePixel = 2
                screen.BorderColor3 = Color3.fromRGB(0, 255, 0)
                screen.Parent = screenGui
                
                local terminalText = Instance.new("TextLabel")
                terminalText.Size = UDim2.new(1, 0, 1, 0)
                terminalText.BackgroundTransparency = 1
                terminalText.Text = "> SYSTEM READY\n> ACCESS_LEVEL: 1\n> AWAITING_INPUT..."
                terminalText.TextColor3 = Color3.fromRGB(0, 255, 0)
                terminalText.TextScaled = true
                terminalText.Font = Enum.Font.Code
                terminalText.TextXAlignment = Enum.TextXAlignment.Left
                terminalText.TextYAlignment = Enum.TextYAlignment.Top
                terminalText.Parent = screen
            end
        end
        
        table.insert(walls, wall)
    end
    
    return walls
end

-- Create massive decoration system with thousands of decorative elements
function ArenaGenerator.createDecorations(platform, arenaData)
    local decorations = {}
    local position = platform.Position
    local size = arenaData.size
    local abundance = arenaData.proceduralElements.decorativeAbundance or 0.7
    
    -- Generate procedural decorations based on biome and theme
    for _, decorationType in pairs(arenaData.decorations) do
        local decorationCount = math.floor(abundance * 10) -- Base count modified by abundance
        
        if decorationType == "massive_pillars" then
            -- Create massive temple pillars with intricate details
            for i = 1, decorationCount do
                local angle = (i - 1) * (math.pi * 2 / decorationCount)
                local radius = math.min(size.X, size.Z) * 0.3
                local pillarPos = position + Vector3.new(
                    math.cos(angle) * radius,
                    size.Y/2 + 20,
                    math.sin(angle) * radius
                )
                
                -- Main pillar shaft
                local pillar = Instance.new("Part")
                pillar.Name = "MassivePillar" .. i
                pillar.Size = Vector3.new(8, 40, 8)
                pillar.Position = pillarPos
                pillar.Anchored = true
                pillar.Material = Enum.Material.Sandstone
                pillar.BrickColor = BrickColor.new(arenaData.theme.accentColor)
                pillar.Parent = workspace
                
                -- Pillar base
                local pillarBase = Instance.new("Part")
                pillarBase.Name = "PillarBase" .. i
                pillarBase.Size = Vector3.new(12, 4, 12)
                pillarBase.Position = pillarPos + Vector3.new(0, -18, 0)
                pillarBase.Anchored = true
                pillarBase.Material = Enum.Material.Marble
                pillarBase.BrickColor = BrickColor.new(arenaData.theme.primaryColor)
                pillarBase.Parent = workspace
                
                -- Pillar capital
                local pillarCapital = Instance.new("Part")
                pillarCapital.Name = "PillarCapital" .. i
                pillarCapital.Size = Vector3.new(10, 3, 10)
                pillarCapital.Position = pillarPos + Vector3.new(0, 18.5, 0)
                pillarCapital.Anchored = true
                pillarCapital.Material = Enum.Material.Marble
                pillarCapital.BrickColor = BrickColor.new(arenaData.theme.accentColor)
                pillarCapital.Parent = workspace
                
                -- Add hieroglyphic carvings
                for face = 1, 4 do
                    local carving = Instance.new("SurfaceGui")
                    carving.Name = "Hieroglyphs_" .. face
                    carving.Face = face == 1 and Enum.NormalId.Front or 
                                  face == 2 and Enum.NormalId.Back or
                                  face == 3 and Enum.NormalId.Left or
                                  Enum.NormalId.Right
                    carving.Parent = pillar
                    
                    for row = 1, 8 do
                        for col = 1, 2 do
                            local hieroglyph = Instance.new("ImageLabel")
                            hieroglyph.Name = "Glyph_" .. row .. "_" .. col
                            hieroglyph.Size = UDim2.new(0, 30, 0, 30)
                            hieroglyph.Position = UDim2.new(
                                (col - 1) * 0.4 + 0.1,
                                0,
                                (row - 1) * 0.12 + 0.02,
                                0
                            )
                            hieroglyph.BackgroundTransparency = 1
                            hieroglyph.ImageTransparency = 0.2
                            hieroglyph.ImageColor3 = Color3.fromRGB(255, 215, 0)
                            hieroglyph.Parent = carving
                        end
                    end
                end
                
                table.insert(decorations, pillar)
                table.insert(decorations, pillarBase)
                table.insert(decorations, pillarCapital)
            end
            
        elseif decorationType == "torch_braziers" then
            -- Create elaborate flame braziers
            for i = 1, decorationCount * 2 do
                local brazierPos = position + Vector3.new(
                    math.random(-size.X/2 + 5, size.X/2 - 5),
                    size.Y/2 + 3,
                    math.random(-size.Z/2 + 5, size.Z/2 - 5)
                )
                
                -- Brazier stand
                local brazierStand = Instance.new("Part")
                brazierStand.Name = "BrazierStand" .. i
                brazierStand.Size = Vector3.new(1, 6, 1)
                brazierStand.Position = brazierPos
                brazierStand.Anchored = true
                brazierStand.Material = Enum.Material.Metal
                brazierStand.BrickColor = BrickColor.new(Color3.fromRGB(40, 40, 40))
                brazierStand.Parent = workspace
                
                -- Brazier bowl
                local brazierBowl = Instance.new("Part")
                brazierBowl.Name = "BrazierBowl" .. i
                brazierBowl.Size = Vector3.new(3, 1, 3)
                brazierBowl.Position = brazierPos + Vector3.new(0, 3.5, 0)
                brazierBowl.Anchored = true
                brazierBowl.Material = Enum.Material.Metal
                brazierBowl.BrickColor = BrickColor.new(Color3.fromRGB(80, 60, 40))
                brazierBowl.Shape = Enum.PartType.Cylinder
                brazierBowl.Parent = workspace
                
                -- Flame effect
                local flame = Instance.new("Fire")
                flame.Size = 8
                flame.Heat = 15
                flame.Color = arenaData.biome == "VOLCANIC" and Color3.fromRGB(255, 100, 0) or Color3.fromRGB(255, 165, 0)
                flame.SecondaryColor = Color3.fromRGB(255, 69, 0)
                flame.Parent = brazierBowl
                
                -- Light source
                local torchLight = Instance.new("PointLight")
                torchLight.Color = flame.Color
                torchLight.Brightness = 2
                torchLight.Range = 25
                torchLight.Parent = brazierBowl
                
                table.insert(decorations, brazierStand)
                table.insert(decorations, brazierBowl)
            end
            
        elseif decorationType == "holographic_displays" then
            -- Create complex holographic information displays
            for i = 1, decorationCount * 3 do
                local holoPos = position + Vector3.new(
                    math.random(-size.X/2 + 10, size.X/2 - 10),
                    size.Y/2 + math.random(5, 15),
                    math.random(-size.Z/2 + 10, size.Z/2 - 10)
                )
                
                -- Holographic projector base
                local projectorBase = Instance.new("Part")
                projectorBase.Name = "HoloProjector" .. i
                projectorBase.Size = Vector3.new(2, 1, 2)
                projectorBase.Position = holoPos + Vector3.new(0, -2, 0)
                projectorBase.Anchored = true
                projectorBase.Material = Enum.Material.Metal
                projectorBase.BrickColor = BrickColor.new(Color3.fromRGB(60, 60, 80))
                projectorBase.Parent = workspace
                
                -- Holographic display
                local holoDisplay = Instance.new("Part")
                holoDisplay.Name = "HoloDisplay" .. i
                holoDisplay.Size = Vector3.new(4, 6, 0.1)
                holoDisplay.Position = holoPos
                holoDisplay.Anchored = true
                holoDisplay.Material = Enum.Material.ForceField
                holoDisplay.BrickColor = BrickColor.new(arenaData.theme.neonColors[math.random(1, #arenaData.theme.neonColors)])
                holoDisplay.Transparency = 0.2
                holoDisplay.Parent = workspace
                
                -- Add holographic content
                local holoGui = Instance.new("SurfaceGui")
                holoGui.Face = Enum.NormalId.Front
                holoGui.Parent = holoDisplay
                
                -- Create scrolling data effect
                for line = 1, 10 do
                    local dataLine = Instance.new("TextLabel")
                    dataLine.Name = "DataLine" .. line
                    dataLine.Size = UDim2.new(1, 0, 0.1, 0)
                    dataLine.Position = UDim2.new(0, 0, (line - 1) * 0.1, 0)
                    dataLine.BackgroundTransparency = 1
                    dataLine.Text = string.rep("█", math.random(10, 20)) .. " " .. math.random(1000, 9999)
                    dataLine.TextColor3 = holoDisplay.BrickColor.Color
                    dataLine.TextScaled = true
                    dataLine.Font = Enum.Font.Code
                    dataLine.Parent = holoGui
                    
                    -- Add scrolling animation
                    spawn(function()
                        while dataLine.Parent do
                            wait(math.random(1, 3))
                            dataLine.Text = string.rep("█", math.random(10, 20)) .. " " .. math.random(1000, 9999)
                        end
                    end)
                end
                
                -- Holographic glow effect
                local holoGlow = Instance.new("PointLight")
                holoGlow.Color = holoDisplay.BrickColor.Color
                holoGlow.Brightness = 1.5
                holoGlow.Range = 15
                holoGlow.Parent = holoDisplay
                
                table.insert(decorations, projectorBase)
                table.insert(decorations, holoDisplay)
            end
            
        elseif decorationType == "bioluminescent_creatures" then
            -- Create underwater bioluminescent life forms
            for i = 1, decorationCount * 4 do
                local creaturePos = position + Vector3.new(
                    math.random(-size.X/2, size.X/2),
                    size.Y/2 + math.random(1, 10),
                    math.random(-size.Z/2, size.Z/2)
                )
                
                local creatureType = math.random(1, 4)
                
                if creatureType == 1 then
                    -- Bioluminescent jellyfish
                    local jellyfish = Instance.new("Part")
                    jellyfish.Name = "BioJellyfish" .. i
                    jellyfish.Size = Vector3.new(3, 2, 3)
                    jellyfish.Position = creaturePos
                    jellyfish.Anchored = true
                    jellyfish.Material = Enum.Material.ForceField
                    jellyfish.BrickColor = BrickColor.new(Color3.fromRGB(0, 255, 200))
                    jellyfish.Transparency = 0.3
                    jellyfish.Shape = Enum.PartType.Ball
                    jellyfish.Parent = workspace
                    
                    -- Add tentacles
                    for tentacle = 1, 6 do
                        local tentaclePart = Instance.new("Part")
                        tentaclePart.Name = "Tentacle" .. tentacle
                        tentaclePart.Size = Vector3.new(0.3, 8, 0.3)
                        tentaclePart.Position = creaturePos + Vector3.new(
                            math.cos(tentacle * math.pi / 3) * 1.2,
                            -4,
                            math.sin(tentacle * math.pi / 3) * 1.2
                        )
                        tentaclePart.Anchored = true
                        tentaclePart.Material = Enum.Material.ForceField
                        tentaclePart.BrickColor = BrickColor.new(Color3.fromRGB(0, 200, 255))
                        tentaclePart.Transparency = 0.4
                        tentaclePart.Parent = workspace
                        
                        table.insert(decorations, tentaclePart)
                    end
                    
                elseif creatureType == 2 then
                    -- Glowing coral polyps
                    local coral = Instance.new("Part")
                    coral.Name = "BiolumCoral" .. i
                    coral.Size = Vector3.new(
                        math.random(2, 6),
                        math.random(4, 10),
                        math.random(2, 6)
                    )
                    coral.Position = creaturePos
                    coral.Anchored = true
                    coral.Material = Enum.Material.Neon
                    coral.BrickColor = BrickColor.new(Color3.fromRGB(255, 100, 200))
                    coral.Transparency = 0.1
                    coral.Parent = workspace
                    
                    -- Add polyp details
                    for polyp = 1, 8 do
                        local polypPart = Instance.new("Part")
                        polypPart.Name = "Polyp" .. polyp
                        polypPart.Size = Vector3.new(0.5, 1, 0.5)
                        polypPart.Position = coral.Position + Vector3.new(
                            math.random(-coral.Size.X/2, coral.Size.X/2),
                            coral.Size.Y/2 + 0.5,
                            math.random(-coral.Size.Z/2, coral.Size.Z/2)
                        )
                        polypPart.Anchored = true
                        polypPart.Material = Enum.Material.Neon
                        polypPart.BrickColor = BrickColor.new(Color3.fromRGB(255, 150, 100))
                        polypPart.Shape = Enum.PartType.Ball
                        polypPart.Parent = workspace
                        
                        table.insert(decorations, polypPart)
                    end
                    
                elseif creatureType == 3 then
                    -- Phosphorescent algae clusters
                    local algaeCluster = Instance.new("Part")
                    algaeCluster.Name = "PhosphoAlgae" .. i
                    algaeCluster.Size = Vector3.new(6, 1, 6)
                    algaeCluster.Position = creaturePos
                    algaeCluster.Anchored = true
                    algaeCluster.Material = Enum.Material.Neon
                    algaeCluster.BrickColor = BrickColor.new(Color3.fromRGB(100, 255, 100))
                    algaeCluster.Transparency = 0.6
                    algaeCluster.Shape = Enum.PartType.Cylinder
                    algaeCluster.Parent = workspace
                    
                    -- Add pulsing glow effect
                    local pulseGlow = Instance.new("PointLight")
                    pulseGlow.Color = Color3.fromRGB(100, 255, 100)
                    pulseGlow.Brightness = 2
                    pulseGlow.Range = 20
                    pulseGlow.Parent = algaeCluster
                    
                    local pulseTween = TweenService:Create(
                        pulseGlow,
                        TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                        {Brightness = 0.5}
                    )
                    pulseTween:Play()
                    
                elseif creatureType == 4 then
                    -- Deep sea anemones
                    local anemone = Instance.new("Part")
                    anemone.Name = "BioAnemone" .. i
                    anemone.Size = Vector3.new(2, 4, 2)
                    anemone.Position = creaturePos
                    anemone.Anchored = true
                    anemone.Material = Enum.Material.ForceField
                    anemone.BrickColor = BrickColor.new(Color3.fromRGB(200, 0, 255))
                    anemone.Transparency = 0.2
                    anemone.Shape = Enum.PartType.Cylinder
                    anemone.Parent = workspace
                    
                    -- Add swaying animation
                    local swayTween = TweenService:Create(
                        anemone,
                        TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                        {Rotation = anemone.Rotation + Vector3.new(0, 0, 15)}
                    )
                    swayTween:Play()
                end
                
                -- Add bioluminescent light to all creatures
                local bioLight = Instance.new("PointLight")
                bioLight.Color = Color3.fromRGB(0, 255, 200)
                bioLight.Brightness = 1.5
                bioLight.Range = 12
                bioLight.Parent = decorations[#decorations]
                
                table.insert(decorations, decorations[#decorations])
            end
        end
    end
    
    return decorations
end

-- Apply advanced lighting and atmospheric settings
function ArenaGenerator.setupLighting(arenaData)
    local lighting = arenaData.lighting
    
    -- Basic lighting setup
    Lighting.Ambient = lighting.ambient
    Lighting.Brightness = lighting.brightness
    Lighting.ClockTime = lighting.clockTime
    Lighting.FogEnd = lighting.fogEnd
    Lighting.FogColor = lighting.fogColor
    
    -- Advanced atmospheric effects
    if not Lighting:FindFirstChild("Atmosphere") then
        local atmosphere = Instance.new("Atmosphere")
        atmosphere.Density = lighting.ambientOcclusion or 0.3
        atmosphere.Offset = 0.25
        atmosphere.Color = lighting.fogColor
        atmosphere.Decay = lighting.fogColor
        atmosphere.Glare = 0.2
        atmosphere.Haze = 1.3
        atmosphere.Parent = Lighting
    end
    
    -- Advanced lighting effects based on arena type
    if arenaData.biome == "VOLCANIC" then
        -- Add volcanic lighting effects
        local volcanicAtmosphere = Lighting:FindFirstChild("Atmosphere")
        if volcanicAtmosphere then
            volcanicAtmosphere.Density = 0.8
            volcanicAtmosphere.Glare = 0.5
            volcanicAtmosphere.Haze = 2.0
        end
        
        -- Create heat shimmer effect
        local heatShimmer = Instance.new("DepthOfFieldEffect")
        heatShimmer.Name = "HeatShimmer"
        heatShimmer.FarIntensity = 0.3
        heatShimmer.FocusDistance = 50
        heatShimmer.InFocusRadius = 20
        heatShimmer.NearIntensity = 0.1
        heatShimmer.Parent = Lighting
        
    elseif arenaData.biome == "CYBERPUNK" then
        -- Add cyberpunk visual effects
        local bloomEffect = Instance.new("BloomEffect")
        bloomEffect.Name = "CyberpunkBloom"
        bloomEffect.Intensity = lighting.bloomIntensity or 0.8
        bloomEffect.Size = 56
        bloomEffect.Threshold = 0.8
        bloomEffect.Parent = Lighting
        
        local colorCorrection = Instance.new("ColorCorrectionEffect")
        colorCorrection.Name = "CyberpunkColor"
        colorCorrection.Brightness = 0.1
        colorCorrection.Contrast = lighting.contrast or 1.5
        colorCorrection.Saturation = lighting.saturation or 1.3
        colorCorrection.TintColor = Color3.fromRGB(0, 150, 255)
        colorCorrection.Parent = Lighting
        
        -- Add scanline effect
        if lighting.scanlines then
            local scanlineEffect = Instance.new("BlurEffect")
            scanlineEffect.Name = "Scanlines"
            scanlineEffect.Size = 2
            scanlineEffect.Parent = Lighting
        end
        
    elseif arenaData.biome == "ARCTIC" then
        -- Add arctic lighting effects
        local sunRays = Instance.new("SunRaysEffect")
        sunRays.Name = "ArcticSunRays"
        sunRays.Intensity = 0.4
        sunRays.Spread = 1.0
        sunRays.Parent = Lighting
        
        local crystallineBloom = Instance.new("BloomEffect")
        crystallineBloom.Name = "CrystallineBloom"
        crystallineBloom.Intensity = 0.4
        crystallineBloom.Size = 24
        crystallineBloom.Threshold = 0.9
        crystallineBloom.Parent = Lighting
        
    elseif arenaData.biome == "OCEANIC" then
        -- Add underwater lighting effects
        local depthBlur = Instance.new("BlurEffect")
        depthBlur.Name = "UnderwaterBlur"
        depthBlur.Size = 3
        depthBlur.Parent = Lighting
        
        local causticEffect = Instance.new("BloomEffect")
        causticEffect.Name = "UnderwaterCaustics"
        causticEffect.Intensity = 0.6
        causticEffect.Size = 32
        causticEffect.Threshold = 0.7
        causticEffect.Parent = Lighting
        
        -- Adjust fog for underwater appearance
        Lighting.FogStart = 0
        Lighting.FogEnd = 80
        Lighting.FogColor = Color3.fromRGB(0, 50, 100)
    end
    
    -- Dynamic lighting based on time of day
    if arenaData.timeOfDay == "SUNSET" then
        local sunRays = Instance.new("SunRaysEffect")
        sunRays.Name = "SunsetRays"
        sunRays.Intensity = 0.8
        sunRays.Spread = 0.6
        sunRays.Parent = Lighting
        
    elseif arenaData.timeOfDay == "MIDNIGHT" then
        Lighting.Brightness = 0.3
        Lighting.Ambient = Color3.fromRGB(20, 20, 50)
        
    elseif arenaData.timeOfDay == "DAWN" then
        local dawnBloom = Instance.new("BloomEffect")
        dawnBloom.Name = "DawnBloom"
        dawnBloom.Intensity = 0.5
        dawnBloom.Size = 48
        dawnBloom.Threshold = 0.6
        dawnBloom.Parent = Lighting
    end
end

-- Create advanced spawn point system with multiple configurations
function ArenaGenerator.createSpawnPoints(platform, arenaData)
    local spawnPoints = {}
    local position = platform.Position
    local spawnHeight = position.Y + arenaData.size.Y/2 + arenaData.spawnHeight
    
    -- Create multiple spawn configurations based on arena type
    if arenaData.name == "Orbital Combat Deck" then
        -- Zero gravity spawn points
        for i = 1, 6 do
            local angle = (i - 1) * (math.pi * 2 / 6)
            local spawnRadius = 30
            local spawn = Instance.new("SpawnLocation")
            spawn.Name = "OrbitalSpawn" .. i
            spawn.Size = Vector3.new(4, 1, 4)
            spawn.Position = position + Vector3.new(
                math.cos(angle) * spawnRadius,
                spawnHeight + math.random(-10, 10),
                math.sin(angle) * spawnRadius
            )
            spawn.Anchored = true
            spawn.BrickColor = BrickColor.new("Bright blue")
            spawn.Material = Enum.Material.ForceField
            spawn.TopSurface = Enum.SurfaceType.Smooth
            spawn.Transparency = 0.3
            spawn.Parent = workspace
            
            -- Add spawn platform glow
            local spawnGlow = Instance.new("PointLight")
            spawnGlow.Color = Color3.fromRGB(0, 150, 255)
            spawnGlow.Brightness = 2
            spawnGlow.Range = 15
            spawnGlow.Parent = spawn
            
            table.insert(spawnPoints, spawn)
        end
        
    elseif arenaData.biome == "VOLCANIC" then
        -- Heat-resistant spawn points
        local spawn1 = Instance.new("SpawnLocation")
        spawn1.Name = "VolcanicSpawn1"
        spawn1.Size = Vector3.new(8, 2, 8)
        spawn1.Position = Vector3.new(position.X - 35, spawnHeight, position.Z)
        spawn1.Anchored = true
        spawn1.BrickColor = BrickColor.new("Really red")
        spawn1.Material = Enum.Material.Basalt
        spawn1.TopSurface = Enum.SurfaceType.Smooth
        spawn1.Parent = workspace
        
        -- Add cooling system
        local coolingSystem = Instance.new("Part")
        coolingSystem.Name = "CoolingSystem1"
        coolingSystem.Size = Vector3.new(2, 6, 2)
        coolingSystem.Position = spawn1.Position + Vector3.new(0, 4, 0)
        coolingSystem.Anchored = true
        coolingSystem.Material = Enum.Material.Metal
        coolingSystem.BrickColor = BrickColor.new("Really black")
        coolingSystem.Parent = workspace
        
        local coolingSteam = Instance.new("Smoke")
        coolingSteam.Size = 5
        coolingSteam.Opacity = 0.3
        coolingSteam.RiseVelocity = 8
        coolingSteam.Parent = coolingSystem
        
        local spawn2 = spawn1:Clone()
        spawn2.Name = "VolcanicSpawn2"
        spawn2.Position = Vector3.new(position.X + 35, spawnHeight, position.Z)
        spawn2.BrickColor = BrickColor.new("Bright red")
        spawn2.Parent = workspace
        
        table.insert(spawnPoints, spawn1)
        table.insert(spawnPoints, spawn2)
        
    elseif arenaData.biome == "OCEANIC" then
        -- Underwater spawn points with air bubbles
        for i = 1, 4 do
            local angle = (i - 1) * (math.pi / 2)
            local spawn = Instance.new("SpawnLocation")
            spawn.Name = "UnderwaterSpawn" .. i
            spawn.Size = Vector3.new(6, 1, 6)
            spawn.Position = position + Vector3.new(
                math.cos(angle) * 25,
                spawnHeight,
                math.sin(angle) * 25
            )
            spawn.Anchored = true
            spawn.BrickColor = BrickColor.new("Bright blue")
            spawn.Material = Enum.Material.Glass
            spawn.TopSurface = Enum.SurfaceType.Smooth
            spawn.Transparency = 0.2
            spawn.Parent = workspace
            
            -- Add air bubble dome
            local airBubble = Instance.new("Part")
            airBubble.Name = "AirBubble" .. i
            airBubble.Size = Vector3.new(10, 8, 10)
            airBubble.Position = spawn.Position + Vector3.new(0, 4, 0)
            airBubble.Anchored = true
            airBubble.Material = Enum.Material.ForceField
            airBubble.BrickColor = BrickColor.new("Cyan")
            airBubble.Transparency = 0.7
            airBubble.Shape = Enum.PartType.Ball
            airBubble.Parent = workspace
            
            table.insert(spawnPoints, spawn)
        end
        
    else
        -- Standard spawn configuration
        local spawn1 = Instance.new("SpawnLocation")
        spawn1.Name = "Player1Spawn"
        spawn1.Size = Vector3.new(6, 1, 6)
        spawn1.Position = Vector3.new(position.X - 25, spawnHeight, position.Z)
        spawn1.Anchored = true
        spawn1.BrickColor = BrickColor.new("Bright blue")
        spawn1.Material = Enum.Material.ForceField
        spawn1.TopSurface = Enum.SurfaceType.Smooth
        spawn1.Parent = workspace
        
        local spawn2 = spawn1:Clone()
        spawn2.Name = "Player2Spawn"
        spawn2.Position = Vector3.new(position.X + 25, spawnHeight, position.Z)
        spawn2.BrickColor = BrickColor.new("Bright red")
        spawn2.Parent = workspace
        
        table.insert(spawnPoints, spawn1)
        table.insert(spawnPoints, spawn2)
    end
    
    return spawnPoints
end

-- Generate complete arena with all advanced systems
function ArenaGenerator.generateArena(arenaType, centerPosition)
    local arenaData = ArenaGenerator.Arenas[arenaType]
    if not arenaData then
        warn("Unknown arena type: " .. tostring(arenaType))
        return nil
    end
    
    centerPosition = centerPosition or Vector3.new(0, 50, 0)
    
    print("Generating " .. arenaData.name .. " arena with advanced systems...")
    
    -- Clear existing arena
    ArenaGenerator.clearArena()
    
    -- Create main platform
    local platform = ArenaGenerator.createArenaPlatform(arenaData, centerPosition)
    
    -- Generate procedural terrain if enabled
    local terrainFeatures = {}
    if arenaData.proceduralElements.terrainComplexity > 0.5 then
        terrainFeatures = generateProceduralTerrain(arenaData, platform, arenaData.proceduralElements.terrainComplexity)
    end
    
    -- Create boundary walls with advanced features
    local walls = ArenaGenerator.createBoundaryWalls(platform, arenaData)
    
    -- Generate complex structures
    local structures = generateComplexStructures(arenaData, platform)
    
    -- Add massive decoration system
    local decorations = ArenaGenerator.createDecorations(platform, arenaData)
    
    -- Create atmospheric effects
    local atmosphericElements = createAtmosphericEffects(arenaData, platform)
    
    -- Setup advanced lighting
    ArenaGenerator.setupLighting(arenaData)
    
    -- Create spawn points
    local spawnPoints = ArenaGenerator.createSpawnPoints(platform, arenaData)
    
    -- Add environmental hazards system
    local hazards = ArenaGenerator.createEnvironmentalHazards(arenaData, platform)
    
    -- Create interactive elements
    local interactives = ArenaGenerator.createInteractiveElements(arenaData, platform)
    
    -- Setup dynamic events system
    ArenaGenerator.setupDynamicEvents(arenaData, platform)
    
    -- Create arena container with all systems
    local arena = {
        name = arenaData.name,
        platform = platform,
        walls = walls,
        decorations = decorations,
        structures = structures,
        terrainFeatures = terrainFeatures,
        atmosphericElements = atmosphericElements,
        spawnPoints = spawnPoints,
        hazards = hazards,
        interactives = interactives,
        arenaData = arenaData,
        biome = arenaData.biome,
        difficulty = arenaData.difficulty,
        culturalInfluence = arenaData.culturalInfluence
    }
    
    print(arenaData.name .. " arena generated successfully with " .. 
          #decorations .. " decorations, " .. 
          #structures .. " structures, " .. 
          #hazards .. " hazards, and " .. 
          #interactives .. " interactive elements!")
    
    return arena
end

-- Create advanced environmental hazards system
function ArenaGenerator.createEnvironmentalHazards(arenaData, platform)
    local hazards = {}
    local position = platform.Position
    local size = arenaData.size
    local hazardDensity = arenaData.proceduralElements.hazardDensity or 0.5
    
    for _, hazardType in pairs(arenaData.environmentalHazards or {}) do
        local hazardCount = math.floor(hazardDensity * 8)
        
        if hazardType == "LAVA_GEYSERS" then
            for i = 1, hazardCount do
                local geyserPos = position + Vector3.new(
                    math.random(-size.X/3, size.X/3),
                    size.Y/2,
                    math.random(-size.Z/3, size.Z/3)
                )
                
                local geyser = Instance.new("Part")
                geyser.Name = "LavaGeyser" .. i
                geyser.Size = Vector3.new(4, 1, 4)
                geyser.Position = geyserPos
                geyser.Anchored = true
                geyser.Material = Enum.Material.Rock
                geyser.BrickColor = BrickColor.new(Color3.fromRGB(60, 30, 30))
                geyser.Parent = workspace
                
                -- Add geyser eruption system
                spawn(function()
                    while geyser.Parent do
                        wait(math.random(5, 15))
                        
                        -- Create lava eruption
                        local eruption = Instance.new("Part")
                        eruption.Name = "LavaEruption"
                        eruption.Size = Vector3.new(3, 20, 3)
                        eruption.Position = geyserPos + Vector3.new(0, 10, 0)
                        eruption.Anchored = true
                        eruption.Material = Enum.Material.Neon
                        eruption.BrickColor = BrickColor.new(Color3.fromRGB(255, 100, 0))
                        eruption.Parent = workspace
                        
                        local eruptionFire = Instance.new("Fire")
                        eruptionFire.Size = 15
                        eruptionFire.Heat = 20
                        eruptionFire.Parent = eruption
                        
                        wait(3)
                        eruption:Destroy()
                    end
                end)
                
                table.insert(hazards, geyser)
            end
            
        elseif hazardType == "ELECTRIC_FIELDS" then
            for i = 1, hazardCount do
                local fieldPos = position + Vector3.new(
                    math.random(-size.X/3, size.X/3),
                    size.Y/2 + 5,
                    math.random(-size.Z/3, size.Z/3)
                )
                
                local electricField = Instance.new("Part")
                electricField.Name = "ElectricField" .. i
                electricField.Size = Vector3.new(6, 10, 6)
                electricField.Position = fieldPos
                electricField.Anchored = true
                electricField.Material = Enum.Material.ForceField
                electricField.BrickColor = BrickColor.new(Color3.fromRGB(0, 255, 255))
                electricField.Transparency = 0.5
                electricField.Parent = workspace
                
                -- Add electric effects
                local sparkle = Instance.new("Sparkles")
                sparkle.SparkleColor = Color3.fromRGB(255, 255, 255)
                sparkle.Parent = electricField
                
                -- Add electric sound
                local electricSound = Instance.new("Sound")
                electricSound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
                electricSound.Volume = 0.3
                electricSound.Looped = true
                electricSound.Parent = electricField
                electricSound:Play()
                
                table.insert(hazards, electricField)
            end
            
        elseif hazardType == "ICE_STORMS" then
            local stormCenter = Instance.new("Part")
            stormCenter.Name = "IceStormCenter"
            stormCenter.Size = Vector3.new(1, 1, 1)
            stormCenter.Position = position + Vector3.new(0, size.Y/2 + 30, 0)
            stormCenter.Anchored = true
            stormCenter.Transparency = 1
            stormCenter.Parent = workspace
            
            local stormEmitter = Instance.new("Attachment")
            stormEmitter.Parent = stormCenter
            
            local iceParticles = Instance.new("ParticleEmitter")
            iceParticles.Texture = "rbxasset://textures/particles/snow_main.dds"
            iceParticles.Lifetime = NumberRange.new(5, 8)
            iceParticles.Rate = 500
            iceParticles.SpreadAngle = Vector2.new(45, 45)
            iceParticles.Speed = NumberRange.new(20, 40)
            iceParticles.Acceleration = Vector3.new(0, -50, 0)
            iceParticles.Color = ColorSequence.new(Color3.fromRGB(200, 230, 255))
            iceParticles.Size = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0.5),
                NumberSequenceKeypoint.new(0.5, 1),
                NumberSequenceKeypoint.new(1, 0.2)
            }
            iceParticles.Parent = stormEmitter
            
            table.insert(hazards, stormCenter)
        end
    end
    
    return hazards
end

-- Create interactive elements system
function ArenaGenerator.createInteractiveElements(arenaData, platform)
    local interactives = {}
    local position = platform.Position
    local size = arenaData.size
    
    for _, elementType in pairs(arenaData.interactiveElements or {}) do
        if elementType == "LEVER_MECHANISMS" then
            local lever = Instance.new("Part")
            lever.Name = "InteractiveLever"
            lever.Size = Vector3.new(2, 4, 1)
            lever.Position = position + Vector3.new(0, size.Y/2 + 2, size.Z/2 - 2)
            lever.Anchored = true
            lever.Material = Enum.Material.Metal
            lever.BrickColor = BrickColor.new(Color3.fromRGB(100, 100, 100))
            lever.Parent = workspace
            
            -- Add click detector
            local clickDetector = Instance.new("ClickDetector")
            clickDetector.MaxActivationDistance = 20
            clickDetector.Parent = lever
            
            clickDetector.MouseClick:Connect(function(player)
                print(player.Name .. " activated arena lever!")
                -- Add lever functionality here
            end)
            
            table.insert(interactives, lever)
            
        elseif elementType == "HOLOGRAM_PROJECTION" then
            local holoProjector = Instance.new("Part")
            holoProjector.Name = "HologramProjector"
            holoProjector.Size = Vector3.new(3, 1, 3)
            holoProjector.Position = position + Vector3.new(10, size.Y/2 + 0.5, 10)
            holoProjector.Anchored = true
            holoProjector.Material = Enum.Material.Metal
            holoProjector.BrickColor = BrickColor.new(Color3.fromRGB(60, 60, 80))
            holoProjector.Parent = workspace
            
            local hologram = Instance.new("Part")
            hologram.Name = "Hologram"
            hologram.Size = Vector3.new(6, 8, 0.1)
            hologram.Position = holoProjector.Position + Vector3.new(0, 5, 0)
            hologram.Anchored = true
            hologram.Material = Enum.Material.ForceField
            hologram.BrickColor = BrickColor.new(Color3.fromRGB(0, 255, 255))
            hologram.Transparency = 0.3
            hologram.Parent = workspace
            
            table.insert(interactives, holoProjector)
            table.insert(interactives, hologram)
        end
    end
    
    return interactives
end

-- Setup dynamic events system
function ArenaGenerator.setupDynamicEvents(arenaData, platform)
    if not arenaData.dynamicEvents or #arenaData.dynamicEvents == 0 then
        return
    end
    
    spawn(function()
        while platform.Parent do
            wait(math.random(30, 120)) -- Random event every 30-120 seconds
            
            local eventType = arenaData.dynamicEvents[math.random(1, #arenaData.dynamicEvents)]
            
            if eventType == "PILLAR_COLLAPSE" then
                print("Dynamic Event: Pillar Collapse!")
                -- Implement pillar collapse logic
                
            elseif eventType == "SYSTEM_CRASH" then
                print("Dynamic Event: System Crash!")
                -- Implement system crash effects
                
            elseif eventType == "GREAT_FREEZE" then
                print("Dynamic Event: Great Freeze!")
                -- Implement freezing effects
                
            elseif eventType == "ALIEN_INVASION" then
                print("Dynamic Event: Alien Invasion!")
                -- Implement alien encounter
                
            elseif eventType == "VOLCANIC_ERUPTION" then
                print("Dynamic Event: Volcanic Eruption!")
                -- Implement volcanic activity
            end
        end
    end)
end

-- Clear existing arena with advanced cleanup
function ArenaGenerator.clearArena()
    -- Remove all arena-related parts
    local arenaNames = {
        "Arena", "Wall", "Pillar", "NeonStrip", "LavaPool", "IceSpike", "FloatingRock", 
        "Spawn", "MassivePillar", "BrazierStand", "BrazierBowl", "HoloProjector", 
        "HoloDisplay", "BioJellyfish", "BiolumCoral", "PhosphoAlgae", "BioAnemone",
        "TerrainChunk", "ZigguratLevel", "HoloStructure", "Crystal", "Tentacle",
        "Polyp", "LavaGeyser", "ElectricField", "IceStormCenter"
    }
    
    for _, obj in pairs(workspace:GetChildren()) do
        for _, arenaName in pairs(arenaNames) do
            if obj.Name:find(arenaName) then
                obj:Destroy()
                break
            end
        end
    end
    
    -- Clear lighting effects
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") or effect.Name == "Atmosphere" then
            effect:Destroy()
        end
    end
    
    -- Reset lighting to defaults
    Lighting.Ambient = Color3.fromRGB(128, 128, 128)
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.FogColor = Color3.fromRGB(192, 192, 192)
end

-- Quick arena selection with advanced filtering
function ArenaGenerator.getRandomArena()
    local arenaTypes = {}
    for arenaType, _ in pairs(ArenaGenerator.Arenas) do
        table.insert(arenaTypes, arenaType)
    end
    return arenaTypes[math.random(1, #arenaTypes)]
end

-- Get arena by difficulty
function ArenaGenerator.getArenaByDifficulty(difficulty)
    local matchingArenas = {}
    for arenaType, arenaData in pairs(ArenaGenerator.Arenas) do
        if arenaData.difficulty == difficulty then
            table.insert(matchingArenas, arenaType)
        end
    end
    
    if #matchingArenas > 0 then
        return matchingArenas[math.random(1, #matchingArenas)]
    else
        return ArenaGenerator.getRandomArena()
    end
end

-- Get arena by biome
function ArenaGenerator.getArenaByBiome(biome)
    local matchingArenas = {}
    for arenaType, arenaData in pairs(ArenaGenerator.Arenas) do
        if arenaData.biome == biome then
            table.insert(matchingArenas, arenaType)
        end
    end
    
    if #matchingArenas > 0 then
        return matchingArenas[math.random(1, #matchingArenas)]
    else
        return ArenaGenerator.getRandomArena()
    end
end

-- Arena statistics and information
function ArenaGenerator.getArenaStats()
    local stats = {
        totalArenas = 0,
        biomes = {},
        difficulties = {},
        architecturalStyles = {},
        culturalInfluences = {}
    }
    
    for arenaType, arenaData in pairs(ArenaGenerator.Arenas) do
        stats.totalArenas = stats.totalArenas + 1
        
        stats.biomes[arenaData.biome] = (stats.biomes[arenaData.biome] or 0) + 1
        stats.difficulties[arenaData.difficulty] = (stats.difficulties[arenaData.difficulty] or 0) + 1
        stats.architecturalStyles[arenaData.architecturalStyle] = (stats.architecturalStyles[arenaData.architecturalStyle] or 0) + 1
        stats.culturalInfluences[arenaData.culturalInfluence] = (stats.culturalInfluences[arenaData.culturalInfluence] or 0) + 1
    end
    
    return stats
end

print("Advanced Arena Generator loaded successfully with " .. 
      ArenaGenerator.getArenaStats().totalArenas .. " arena types!")

return ArenaGenerator