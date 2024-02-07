# Static Report

# Define variable names for data columns
id.name <- "id"
Age.name <- "Age"
Gender.name <- "Gender"
Income.name <- "Income"
Region.name <- "Region"
Persona.name <- "Persona"
Product.name <- "Product"
Awareness.name <- "Awareness"
Consideration.name <- "Consideration"
Consumption.name <- "Consumption"
Satisfaction.name <- "Satisfaction"
Advocacy.name <- "Advocacy"

# Define new variables created for new data columns for calculations
Awareness_Score.name <- "Awareness_Score"
Consideration_Score.name <- "Consideration_Score"
Consumption_Score.name <- "Consumption_Score"
Advocacy_Score.name <- "Advocacy_Score"
Satisfaction_Score.name <- "Satisfaction_Score"
Aggregated_engagement.name <- "Aggregated_engagement"

# Define variables names for each unique values for respondent columns

#Region
Region.South.name <- "South"
Region.Midwest.name <- "Midwest"
Region.West.name <- "West"
Region.Northeast.name <- "Northeast"

#Gender
Gender.Male.name <- "Male"
Gender.Female.name <- "Female"
Gender.Other.name <- "Other"

#Persona
Persona.PrecociouslyPreoccupied.name <- "Precociously Preoccupied"
Persona.TechnologicalTriumphalist.name <- "Technological Triumphalist"
Persona.AmbivalentAdventurer.name <- "Ambivalent Adventurer"
Persona.OutdoorsyOmbudsman.name <- "Outdoorsy Ombudsman"
Persona.ConsistentCompromiser.name <- "Consistent Compromiser"
Persona.MaterialisticMeditator.name <- "Materialistic Meditator"

# Divide the Age and Income columns into given brackets
Age.Groups <- c(18, 35, 50, 65, Inf)
Income.Groups <- c(-Inf, 50000, 75000, 100000, 150000, Inf)
Age.Group.Labels <- c("18-34", "35-49", "50-64", "65+")
Income.Group.Labels <- c("<50K", "50-75K", "75-100K", "100-150K", "150K+")

# Positive and Negative perceptions
positive_perceptions <- c("BP_User_Friendly_0_10", "BP_Fast_0_10", "BP_Battery_Life_0_10", "BP_Camera_0_10", "BP_Sleek_0_10", "BP_Stylish_0_10", "BP_Status_Symbol_0_10", "BP_Good_Screen_Size_0_10")
negative_perceptions <- c("BP_Boring_0_10", "BP_Bulky_0_10", "BP_Fragile_0_10", "BP_Expensive_0_10")

all_perceptions <- c(positive_perceptions, negative_perceptions)

# Binary Outcomes
binary_outcomes <- c("Awareness", "Consideration", "Consumption", "Advocacy")
integer_outcomes <- c("Satisfaction")
all_outcomes <- c("Awareness", "Consideration", "Consumption", "Advocacy", "Satisfaction")

#Products
Product.Smartophonic.name <- "Smartophonic"
Product.MobilitEE.name <- "MobilitEE"
Product.Screenz.name <- "Screenz"
Product.NextText.name <- "Next Text"
Product.MaybeMobile.name <- "Maybe Mobile"
Product.AppMap.name <- "App Map"
Product.PhoneZone.name <- "Phone Zone"
Product.SpeedDials.name <- "Speed Dials"
Products.CommunicNation.name <- "Communic Nation"
Products.Mobzilla.name <- "Mobzilla"
Products.Phonatics.name <- "Phonatics"
Products.RingRing.name <- "Ring Ring"
Products.NoButtons.name <- "No Buttons"
Products.AllButtons.name <- "All Buttons"
Products.Buzzdial.name <- "Buzzdial"
Products.MobileMayhem.name <- "Mobile Mayhem"
Products.Triumphone.name <- "Triumphone"
Products.Cellularity.name <- "Cellularity"
Products.PocketDialz.name <- "Pocket Dialz"
Products.OfftheHook.name <- "Off the Hook"

all_products <- c(Product.Smartophonic.name, Product.MobilitEE.name, Product.Screenz.name,
                  Product.NextText.name, Product.MaybeMobile.name, Product.AppMap.name,
                  Product.PhoneZone.name, Product.SpeedDials.name, Products.CommunicNation.name,
                  Products.Mobzilla.name, Products.Phonatics.name, Products.RingRing.name,
                  Products.NoButtons.name, Products.AllButtons.name, Products.Buzzdial.name,
                  Products.MobileMayhem.name, Products.Triumphone.name, Products.Cellularity.name,
                  Products.PocketDialz.name, Products.OfftheHook.name)

# Dynamic App

# Respondent variables
respondent.variables <- c("Age_Group", "Gender", "Income_Group", "Region", "Persona")
AgeGroupRVName <- "Age_Group"
GenderRVName <- "Gender"
IncomeGroupRVName <- "Income_Group"
RegionRVName <- "Region"
PersonaRVName <- "Persona"
AggregatedEngagementName <- "Aggregated_engagement"
BrandPerceptionName <- "Brand Perceptions"

# State of Engagement
states.of.engagement <- all_outcomes
unique.age.groups <- Age.Group.Labels
unique.genders <- c(Gender.Male.name, Gender.Female.name, Gender.Other.name)
unique.income.groups <- Income.Group.Labels
unique.regions <- c(Region.South.name, Region.Midwest.name, Region.West.name, Region.Northeast.name)
unique.personas <- c(Persona.PrecociouslyPreoccupied.name, Persona.TechnologicalTriumphalist.name,
                     Persona.AmbivalentAdventurer.name, Persona.OutdoorsyOmbudsman.name, 
                     Persona.ConsistentCompromiser.name, Persona.MaterialisticMeditator.name)
unique.brand.perceptions <- c("User Friendly", "Fast", "Battery Life", "Camera", "Sleek", "Stylish",
                              "Status Symbol", "Good Screen Size", "Boring", "Bulky", "Fragile",
                              "Expensive")
unique.products <- c(Product.Smartophonic.name, Product.MobilitEE.name, Product.Screenz.name,
                     Product.NextText.name, Product.MaybeMobile.name, Product.AppMap.name,
                     Product.PhoneZone.name, Product.SpeedDials.name, Products.CommunicNation.name,
                     Products.Mobzilla.name, Products.Phonatics.name, Products.RingRing.name,
                     Products.NoButtons.name, Products.AllButtons.name, Products.Buzzdial.name,
                     Products.MobileMayhem.name, Products.Triumphone.name, Products.Cellularity.name,
                     Products.PocketDialz.name, Products.OfftheHook.name)

model.variables <- c(AgeGroupRVName, GenderRVName, IncomeGroupRVName, RegionRVName, PersonaRVName, 
                     AggregatedEngagementName, BrandPerceptionName)