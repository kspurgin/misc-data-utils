#!/usr/bin/env ruby

require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'pry'
end

require 'fileutils'

existing_dir = '~/data/CSWS/ui'
target_dir = '~/data/CSWS/tables_not_migrating_ui'

def main_not_migrating
  [
    'AcsnDocs.tsv',
    'AcsnsEachEstValSumByContact.tsv',
    'BenDistinct.tsv',
    'Changes.tsv',
    'CollectionsDonors111013.tsv',
    'Computers.tsv',
    'ContactFriendsTour.tsv',
    'ContactId+DonatnValu.tsv',
    'ContactImages.tsv',
    'Contacts+Types.tsv',
    'ContactsAddressHistory.tsv',
    'CreatorsNeedArtistType.tsv',
    'DDDatabases.tsv',
    'DDFields.tsv',
    'DDTables.tsv',
    'DeacsnRetentions.tsv',
    'ExhibitDocs.tsv',
    'ExhibitGuests.tsv',
    'ExhibitImages.tsv',
    'ExhibitLabels.tsv',
    'ExhibitsTrans.tsv',
    'FriendsAcsns.tsv',
    'FriendsAll.tsv',
    'FriendsTypes.tsv',
    'GenreList.tsv',
    'GenreListTabNeeded.tsv',
    'GeoPlaces.tsv',
    'ImagesLegacy.tsv',
    'ImagesLegacy2Collection.tsv',
    'ImagesLegacy2Count.tsv',
    'ImagesLegacy2DigitalProcesses.tsv',
    'ImagesLegacy2HxW.tsv',
    'ImagesLegacy2Location.tsv',
    'ImagesLegacy2Materials.tsv',
    'ImagesLegacyAcsn#Coll.tsv',
    'InkUse.tsv',
    'ItemDocs.tsv',
    'ItemGeoPlaces.tsv',
    'ItemLcshs.tsv',
    'ItemNamesCorp.tsv',
    'ItemNamesPers.tsv',
    'Items_copy.tsv',
    'Items2Location.tsv',
    'Lcshs.tsv',
    'Mailing.tsv',
    'Maps.tsv',
    'MarcRecords.tsv',
    'Name_AutoCorrect_Save_Failures.tsv',
    'Numbers2.tsv',
    'Numbers3.tsv',
    'Numbers4.tsv',
    'Paste_Errors.tsv',
    'Photos.tsv',
    'PostcardsNew.tsv',
    'PrinterInks.tsv',
    'Printers.tsv',
    'RemnantPieces.tsv',
    'Remnants.tsv',
    'RiflesIdOtherId.tsv',
    'RollPapers.tsv',
    'Rolls.tsv',
    'RollUse.tsv',
    'SoukiiniGuests.tsv',
    'USGS_Gen.tsv',
    'USGSMAPS.tsv'
  ]
end

def ui_not_migrating
  [
    'CollectionTitleFromImagesLegacy.tsv',
    'DonorsFromImagesLegacy541.tsv',
    'Items180606.tsv',
    'ItemTreatment_ExportErrors.tsv',
    'LocationHistory_ExportErrors.tsv',
    'LocationHistory_ExportErrors1.tsv',
    'NegativeTypes.tsv',
    'Paste_Errors.tsv',
    'PhotographerNames.tsv',
    'PhysMatSpec.tsv',
    'Prints.tsv',
    'Values_ExportErrors.tsv'
  ]
end

file_list = ui_not_migrating

move_from = File.expand_path(existing_dir)
move_to = File.expand_path(target_dir)
FileUtils.mkdir_p(move_to)

file_list.each do |filename|
  current_file = "#{move_from}/#{filename}"
  unless File.file?(current_file)
    puts "#{current_file} not found in #{move_from}"
    next
  end

  FileUtils.mv(current_file, "#{move_to}/#{filename}")
end
