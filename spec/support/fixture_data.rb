module FixtureData
  module_function

  def prison
    prisons.sample
  end

  def prisons
    [
      'Altcourse','Ashfield', 'Askham Grange', 'Aylesbury', 'Bedford', 'Belmarsh',
      'Birmingham', 'Blantyre House', 'Blundeston', 'Brinsford', 'Bristol','Brixton',
      'Bronzefield','Buckley Hall','Bullingdon','Bure','Cardiff','Channings Wood',
      'Chelmsford','Coldingley','Cookham Wood','Dartmoor',
      'Deerbolt','Doncaster','Dovegate','Dover','Downview','Drake Hall','Durham',
      'East Sutton Park','Eastwood Park','Erlestoke','Everthorpe','Exeter','Featherstone','Feltham','Ford','Forest Bank',
      'Foston Hall','Frankland','Full Sutton','Garth','Gartree','Glen Parva','Grendon','Guys Marsh',
      'Haslar','Hatfield','Haverigg','Hewell','High Down','Highpoint North','Highpoint South','Hindley',
      'Hollesley Bay','Holloway','Holme House','Hull','Huntercombe','Isis','Albany','Parkhurst',
      'Kennet','Kirkham','Kirklevington Grange','Lancaster Farms','Leeds','Leicester','Lewes','Leyhill',
      'Lincoln','Lindholme','Littlehey','Liverpool','Long Lartin','Low Newton','Lowdham Grange','Maidstone',
      'Manchester','Moorland','Morton Hall','New Hall','Northumberland','North Sea Camp','Northallerton','Norwich',
      'Nottingham','Onley','Oakwood','Parc','Pentonville','Peterborough','Portland','Prescoed',
      'Preston','Ranby','Risley','Rochester','Rye Hill','Send','Elmley','Standford Hill',
      'Swaleside','Spring Hill','Stafford','Stocken','Stoke Heath','Styal','Sudbury','Swansea',
      'Swinfen Hall','Thameside','The Mount','The Verne','Thorn Cross','Usk','Wakefield','Wandsworth',
      'Warren Hill','Wayland','Wealstun','Werrington','Wetherby','Whatton','Whitemoor','Winchester',
      'Wolds','Woodhill','Wormwood Scrubs','Wymott'
    ]
  end

  def county_court
    county_courts.sample
  end

  def county_courts
    [
      'Aberystwyth','Accrington','Aldershot and Farnham','Altrincham','Aylesbury','Banbury',
      'Barnet','Barnsley','Barnstaple','Barrow-in-Furness','Basildon','Basingstoke',
      'Bath','Bedford','Birkenhead','Birmingham','Blackburn','Blackpool',
      'Blackwood','Bodmin','Bolton','Boston','Bournemouth and Poole','Bow','Bradford',
      'Brecon','Brentford','Bridgend','Brighton','Bristol','Bromley','Burnley','Bury',
      'Bury St Edmunds','Buxton','Caernarfon','Cambridge','Canterbury','Cardiff','Carlisle',
      'Carmarthen','Central London','Chelmsford','Chester','Chesterfield','Chichester','Chippenham and Trowbridge',
      'Clerkenwell and Shoreditch','Colchester','Conwy and Colwyn','Coventry','Crewe','Croydon','Darlington','Dartford',
      'Derby','Doncaster','Dudley','Durham','Eastbourne','Edmonton','Exeter',
      'Gateshead','Gloucester and Cheltenham','Great Grimsby','Guildford','Halifax','Hammersmith','Harrogate','Hartlepool',
      'Hastings','Haverfordwest','Hereford','Hertford','High Wycombe','Horsham','Huddersfield','Ipswich',
      'Isle of Wight','Kendal','Kettering','King\'s Lynn','Kingston-upon-Hull','Kingston-upon-Thames','Lambeth','Lancaster',
      'Leeds','Leicester','Lewes','Lincoln','Liverpool','Llanelli','Llangefni','Lowestoft',
      'Luton','Macclesfield','Maidstone','Manchester','Mansfield','Mayor\'s and City of London Court','Medway','Merthyr Tydfil',
      'Middlesbrough','Milton Keynes','Mold','Morpeth and Berwick','Neath and Port Talbot','Newcastle upon Tyne','Newport','North Shields',
      'Northampton','Norwich','Nottingham','Nuneaton','Oldham','Oxford','Peterborough','Plymouth','Pontypridd',
      'Portsmouth','Preston','Reading','Reigate','Rhyl','Romford','Rotherham','Salisbury','Scarborough',
      'Scunthorpe','Sheffield','Skipton','Slough','South Shields','Southampton','Southend','St Albans',
      'St Helens','Stafford','Staines','Stockport','Stoke-on-Trent','Sunderland','Swansea','Swindon',
      'Tameside','Taunton','Telford','Thanet','Torquay and Newton Abbot','Truro','Tunbridge Wells','Uxbridge','Wakefield',
      'Walsall','Wandsworth','Warrington','Warwick','Watford','Welshpool','West Cumbria','Weston-super-Mare',
      'Weymouth','Wigan','Willesden','Winchester','Wolverhampton','Woolwich','Worcester','Worksop',
      'Worthing','Wrexham','Yeovil','York'
    ]
  end

  def magistrates_court
    MagistratesCourt.pluck(:name).sample
  end

  def bedford_prison
    Prison.find_by_sso_id('bedford.prisons.noms.moj')
  end
end
