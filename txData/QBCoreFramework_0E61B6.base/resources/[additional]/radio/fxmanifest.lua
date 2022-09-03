fx_version 'bodacious'
game 'gta5'

author 'Hellslicer'
description 'This resource allows you to integrate your own radios in place of the original radios'
version '2.0.0'

-- Example custom radios
supersede_radio 'RADIO_01_CLASS_ROCK' { url = 'https://broadcast.ice.infomaniak.ch/aswat-high.mp3', volume = 0.3, name = 'ASWAT RADIO' }
supersede_radio 'RADIO_02_POP' { url = 'https://streamer.eagrpservices.com/audio/medradio.mp3', volume = 0.3, name = 'MED RADIO' }
supersede_radio 'RADIO_03_HIPHOP_NEW' { url = 'https://streamer.eagrpservices.com/audio/mfmradio.ogg', volume = 0.3, name = 'MFM RADIO' }
supersede_radio 'RADIO_04_PUNK' { url = 'https://streamer.eagrpservices.com/audio/chadafm.mp3', volume = 0.3, name = 'CHADA FM' }
supersede_radio 'RADIO_05_TALK_01' { url = 'https://streamer.eagrpservices.com/audio/radiomars.mp3', volume = 0.3, name = 'RADIO MARS' }
supersede_radio 'RADIO_06_COUNTRY' { url = 'https://hitradio-maroc.ice.infomaniak.ch/hitradio-maroc-128.mp3', volume = 0.3, name = 'HIT RADIO' }
supersede_radio 'RADIO_07_DANCE_01' { url = 'http://mgharba.ice.infomaniak.ch/mgharba-128.mp3', volume = 0.3, name = 'HIT RADIO 100% MGHARBA' }
supersede_radio 'RADIO_08_MEXICAN' { url = 'https://plainedge.ice.infomaniak.ch/radiosoleil-128.mp3', volume = 0.3, name = 'RADIO SOLEIL' }
supersede_radio 'RADIO_09_HIPHOP_OLD' { url = 'https://streamer.eagrpservices.com/audio/capradio.mp3', volume = 0.3, name = 'CAP RADIO' }
supersede_radio 'RADIO_11_TALK_02' { url = 'https://medinafm.ice.infomaniak.ch/medinafm-64.mp3', volume = 0.3, name = 'MEDINA FM' }

files {
	'index.html'
}

ui_page 'index.html'

client_scripts {
	'data.js',
	'client.js'
}
