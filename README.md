Compass
=======
API Documentation and Methodology

**Methodology: **

All of our data is based on publically available Federal Election Commission's (FEC) records and publicly stated positions from various funding organizations. The FEC data came by way of the Sunshine API with the funders’ positions via the SunLight API. Agreement Score and its indexed metric, Influence Rank, are calculated after taking into account a legislator vote and his/her funder’s position on the same bill. The more often a legislator agreed with one of his or her funding organizations, the higher the Agreement Score with a particular funding industry and overall Influence Rank. Ideology rank is based on congressional scorecards from the That's My Congress dataset. 

**API Documentation:**

This is the documentation for version 1 of the Civic-Compass API. Below are the endpoints for the; there is no API required so you can begin working with the API right away. 

**Root URI**

All endpoints are relative to the following URI:

`http://api.civic-compass.org/api/v1/[endpoint].[format]`

**Verbs**

All of the following endpoints respond only to `GET` calls

**Format**

Currently, the API returns JSON only although version 2.0 might add to this. Until then, please exclusively use json as your format.

**Find Legislators by Address	**

Find your local legislators using your street address

`/search`

Parameters

* `address`

Example

`http://api.civic-compass.org/api/v1/search.json?address=208%20W.%20Lavendar,%20Ave,%20Durham,%20NC%2027704`

Reponse

`{  "legislators": [{    "firstname": "Richard",    "lastname": "Burr",    "state": "NC",    "party": "Republican",    "title": "sen",    "picture_url": "http://theunitedstates.io/images/congress/225x275/B001135.jpg",    "bioguide_id": "B001135"  }, {    "firstname": "Kay",    "lastname": "Hagan",    "state": "NC",    "party": "Democrat",    "title": "sen",    "picture_url": "http://theunitedstates.io/images/congress/225x275/H001049.jpg",    "bioguide_id": "H001049"  }, {    "firstname": "George",    "lastname": "Butterfield",    "state": "NC",    "party": "Democrat",    "title": "rep",    "picture_url": "http://theunitedstates.io/images/congress/225x275/B001251.jpg",    "bioguide_id": "B001251"  }]}`

**Get Legislator Profile**

Get the profile of a single legislator

`/profile`

Parameters

* `lastname`

* `state`

* `title`

Example

`http://api.civic-compass.org/api/v1/profile.json?lastname=Burr&state=NC&title=sen`

Reponse

`{  "legislators": [{    "firstname": "Richard",    "lastname": "Burr",    "state": "NC",    "party": "Republican",    "title": "sen",    "picture_url": "http://theunitedstates.io/images/congress/225x275/B001135.jpg",    "bioguide_id": "B001135",    "website": "http://www.burr.senate.gov",    "phone": "202-224-3154",    "district": "Senior Seat",    "twitter_id": "SenatorBurr"  }]}`

**Get Legislator’s Elections Timeline**

Get the election timeline for a single legislator

`/elections_timeline`

Parameters

* `lastname`

* `state`

* `title`

Example

`http://api.civic-compass.org/api/v1/elections_timeline.json?lastname=Burr&state=NC&title=sen`

Reponse

`{`

`    "legislators": [`

`        {`

`            "firstname": "Richard",`

`            "lastname": "Burr",`

`            "state": "NC",`

`            "party": "Republican",`

`            "title": "sen",`

`            "elections_timeline_array": [`

`                {`

`                    "type": "rep",`

`                    "start": "1995-01-04",`

`                    "end": "1996-10-04",`

`                    "state": "NC",`

`                    "district": 5,`

`                    "party": "Republican"`

`                },`

`                {`

`                    "type": "rep",`

`                    "start": "1997-01-07",`

`                    "end": "1998-12-19",`

`                    "state": "NC",`

`                    "district": 5,`

`                    "party": "Republican"`

`                },`

`                {`

`                    "type": "rep",`

`                    "start": "1999-01-06",`

`                    "end": "2000-12-15",`

`                    "state": "NC",`

`                    "district": 5,`

`                    "party": "Republican"`

`                },`

`                {`

`                    "type": "rep",`

`                    "start": "2001-01-03",`

`                    "end": "2002-11-22",`

`                    "state": "NC",`

`                    "district": 5,`

`                    "party": "Republican"`

`                },`

`                {`

`                    "type": "rep",`

`                    "start": "2003-01-07",`

`                    "end": "2004-12-09",`

`                    "state": "NC",`

`                    "district": 5,`

`                    "party": "Republican",`

`                    "url": "http://www.house.gov/burr"`

`                }`

`            ]`

`        }`

`    ]`

`}`

**Get Legislator’s Contributors by Type**

Get the contributors type (PAC vs individual) percentage breakdown for a single legislator

`/contributors_by_type`

Parameters

* `lastname`

* `state`

* `title`

Example

`http://api.civic-compass.org/api/v1/contributors_by_type.json?lastname=Burr&state=NC&title=sen`

Reponse

`{`

`    "legislators": [`

`        {`

`            "firstname": "Richard",`

`            "lastname": "Burr",`

`            "state": "NC",`

`            "party": "Republican",`

`            "title": "sen",`

`            "contributors_by_type": {`

`                "Individuals": 65,`

`                "PACs": 35`

`            }`

`        }`

`    ]`

`}`

**Get Legislator’s Top Contributors**

Get the top contributors for a single legislator

`/top_contributors`

Parameters

* `lastname`

* `state`

* `title`

Example

`http://api.civic-compass.org/api/v1/top_contributors.json?lastname=Burr&state=NC&title=sen`

Reponse

`{`

`    "legislators": [`

`        {`

`            "firstname": "Richard",`

`            "lastname": "Burr",`

`            "state": "NC",`

`            "party": "Republican",`

`            "title": "sen",`

`            "top_contributors": [`

`                {`

`                    "employee_amount": "160577.00",`

`                    "total_amount": "170577.00",`

`                    "total_count": "243",`

`                    "name": "Womble, Carlyle et al",`

`                    "direct_count": "4",`

`                    "employee_count": "239",`

`                    "id": "6bc519b91c0a4879a12371627d26dedb",`

`                    "direct_amount": "10000.00"`

`                },`

`                {`

`                    "employee_amount": "152301.00",`

`                    "total_amount": "152301.00",`

`                    "total_count": "187",`

`                    "name": "Reynolds American",`

`                    "direct_count": "0",`

`                    "employee_count": "187",`

`                    "id": "56a0b5c5b3f842a88cabe692ead86fa6",`

`                    "direct_amount": "0"`

`                }`

`            ]`

`        }`

`    ]`

`}`

**Get Legislator’s Most Recent Votes**

Gets the most recent votes of a single legislator

`/most_recent_votes`

Parameters

* `lastname`

* `state`

* `title`

Example

`http://api.civic-compass.org/api/v1/most_recent_votes.json?lastname=Burr&state=NC&title=sen`

Reponse

`{`

`    "legislators": [`

`        {`

`            "firstname": "Richard",`

`            "lastname": "Burr",`

`            "state": "NC",`

`            "party": "Republican",`

`            "title": "sen",`

`            "most_recent_votes": [`

`                {`

`                    "date": "2014-11-18",`

`                    "vote_value": "Yes",`

`                    "vote_description": "S. 2280: A bill to approve the Keystone XL Pipeline."`

`                },`

`                {`

`                    "date": "2014-11-17",`

`                    "vote_value": "Yes",`

`                    "vote_description": "S. 1086: Child Care and Development Block Grant Act of 2014"`

`                },`

`                {`

`                    "date": "2014-09-18",`

`                    "vote_value": "Yes",`

`                    "vote_description": "H.J.Res. 124: Continuing Appropriations Resolution, 2015"`

`                }`

`            ]`

`        }`

`    ]`

`}`

**Get Legislator’s Contributions by Industry**

Gets the most recent votes of a single legislator

`/contributions_by_industry`

Parameters

* `lastname`

* `state`

* `title`

Example

`http://api.civic-compass.org/api/v1/contributions_by_industry.json?lastname=Burr&state=NC&title=sen`

Reponse

`{`

`    "legislators": [`

`        {`

`            "firstname": "Richard",`

`            "lastname": "Burr",`

`            "state": "NC",`

`            "party": "Republican",`

`            "title": "sen",`

`            "contributions_by_industry": {`

`                "Securities And Investment": 35800,`

`                "Health Services / Hm Os": 27000,`

`                "Joint Candidate Cmte": 1285658,`

`                "Chemical And Related Manufacturing": 28000,`

`                "Leadership Pa Cs": 10000,`

`                "Pharmaceuticals / Health Products": 148100,`

`                "Insurance": 54500,`

`                "Real Estate": 244945,`

`                "Health Professionals": 36900,`

`                "Air Transport": 5000,`

`                "Party Committees": 415543,`

`                "Tobacco": 17300,`

`                "Business Associations": 126763,`

`                "Food Processing And Sales": 29300,`

`                "Agricultural Services / Products": 15000,`

`                "Electric Utilities": 29000,`

`                "Food And Beverage": 23000,`

`                "Forestry And Forest Products": 7000,`

`                "Transportation Unions": 5000,`

`                "Retail Sales": 2500,`

`                "Gun Rights": 188192,`

`                "Hospitals / Nursing Homes": 18600,`

`                "Abortion Policy / Pro Life": 64159,`

`                "Finance / Credit Companies": 7000,`

`                "Retired": 126800,`

`                "Misc Energy": 6500,`

`                "Employer Listed / Category Unknown": 29800,`

`                "Automotive": 2500,`

`                "Lawyers / Law Firms": 35900,`

`                "Railroads": 14500,`

`                "Misc Transport": 8000,`

`                "Computers / Internet": 35300,`

`                "Beer, Wine And Liquor": 24050,`

`                "Lobbyists": 11500,`

`                "Misc Finance": 27400,`

`                "Homemakers / Non Incomeearners": 32850,`

`                "Special Trade Contractors": 4000,`

`                "Misc Manufacturing And Distributing": 12500,`

`                "Oil And Gas": 16300,`

`                "Misc Defense": 3000,`

`                "Business Services": 43500,`

`                "Crop Production And Basic Processing": 26800,`

`                "Environment": 2300,`

`                "Textiles": 14600,`

`                "Defense Aerospace": 7000,`

`                "Misc Business": 43000,`

`                "Building Trade Unions": 1500,`

`                "Commercial Banks": 8900,`

`                "General Contractors": 12300,`

`                "No Employer Listedor Found": 4300,`

`                "Credit Unions": 1000,`

`                "Education": 15000,`

`                "Trucking": 14000,`

`                "Other": 2000,`

`                "Telecom Services And Equipment": 12000,`

`                "Lodging / Tourism": 2000,`

`                "Telephone Utilities": 20000,`

`                "Misc Services": 10000,`

`                "Electronics Mfg And Services": 10000,`

`                "Defense Electronics": 1000,`

`                "Building Materials And Equipment": 2000`

`            }`

`        }`

`    ]`

`}`

**Get Legislator’s Agreement Score by Industry**

Gets the industry agreement scores for a single legislator

`/agreement_score_by_industry`

Parameters

* `lastname`

* `state`

* `title`

Example

`http://api.civic-compass.org/api/v1/agreement_score_by_industry.json?lastname=Burr&state=NC&title=sen`

Reponse

`{`

`    "legislators": [`

`        {`

`            "firstname": "Richard",`

`            "lastname": "Burr",`

`            "state": "NC",`

`            "party": "Republican",`

`            "title": "sen",`

`            "agreement_score_by_industry": {`

`                "Oil And Gas": 0.5302013422818792,`

`                "Building Trade Unions": 0.0136986301369863,`

`                "Business Associations": 0.3212121212121212,`

`                "Building Materials And Equipment": 0.2413793103448276,`

`                "Construction Services": -0.07042253521126761,`

`                "Misc Services": 0.25925925925925924,`

`                "General Contractors": 0.1891891891891892,`

`                "Misc Manufacturing And Distributing": 0.32272727272727275,`

`                "Steel Production": 0.3953488372093023,`

`                "Special Trade Contractors": 0.4457831325301205,`

`                "Environment": -0.13953488372093023,`

`                "Industrial Unions": -0.12149532710280374,`

`                "Republican / Conservative": 0.2537313432835821,`

`                "Misc Issues": 0.14871794871794872,`

`                "Transportation Unions": -0.08641975308641975,`

`                "Human Rights": -0.19875776397515527,`

`                "Public Sector Unions": 0,`

`                "Health Professionals": -0.2372093023255814,`

`                "Education": 0.23148148148148148,`

`                "Women's Issues": -0.04294478527607362,`

`                "Misc Unions": -0.21212121212121213,`

`                "Hospitals / Nursing Homes": 0.2982456140350877,`

`                "Other": -0.08571428571428572,`

`                "Chemical And Related Manufacturing": 0.4434782608695652,`

`                "Retail Sales": 0.4125874125874126,`

`                "Trucking": 0.3469387755102041,`

`                "Lodging / Tourism": 0.10714285714285714,`

`                "Agricultural Services / Products": 0.168141592920354,`

`                "Civil Servants / Public Officials": 0.11711711711711711,`

`                "Real Estate": 0.5973154362416108,`

`                "Misc Transport": 0.10843373493975904,`

`                "Air Transport": 0.2289156626506024,`

`                "Automotive": 0.0684931506849315,`

`                "Recreation / Live Entertainment": 0.5897435897435898,`

`                "Misc Business": 0.16129032258064516,`

`                "Electronics Mfg And Services": 0.06666666666666667,`

`                "Sea Transport": 0.18072289156626506,`

`                "Commercial Banks": 0.4222222222222222,`

`                "Insurance": 0.32222222222222224,`

`                "Securities And Investment": -0.11864406779661017,`

`                "Electric Utilities": 0.2857142857142857,`

`                "Railroads": -0.14285714285714285,`

`                "Non Profit Institutions": -0.34615384615384615,`

`                "Food Processing And Sales": 0.4497354497354497,`

`                "Misc Finance": 0.23809523809523808,`

`                "Home Builders": 0.5652173913043478,`

`                "Food And Beverage": 0.3055555555555556,`

`                "Clergy And Religious Organizations": -0.4088050314465409,`

`                "Business Services": 0.25925925925925924,`

`                "Misc Agriculture": -0.23529411764705882,`

`                "Tv / Movies / Music": -0.1,`

`                "Defense Aerospace": 0.3333333333333333,`

`                "Telephone Utilities": -0.09090909090909091,`

`                "Mining": 0.40540540540540543,`

`                "Crop Production And Basic Processing": 0.11884057971014493,`

`                "Misc Energy": -0.07692307692307693,`

`                "Pharmaceuticals / Health Products": 0.38461538461538464,`

`                "Computers / Internet": -0.061946902654867256,`

`                "Foreign And Defense Policy": 0.2903225806451613,`

`                "Textiles": 0.4666666666666667,`

`                "Livestock": 0.05660377358490566,`

`                "Dairy": 0.18518518518518517,`

`                "Beer, Wine And Liquor": 0.030303030303030304,`

`                "Poultry And Eggs": 0.36585365853658536,`

`                "Misc Health": -0.3978494623655914,`

`                "Health Services / Hm Os": -0.18181818181818182,`

`                "Credit Unions": 0.5483870967741935,`

`                "Fisheries And Wildlife": -0.6153846153846154,`

`                "Democratic / Liberal": 0.16666666666666666,`

`                "Lawyers / Law Firms": -0.058823529411764705,`

`                "Forestry And Forest Products": 0.1,`

`                "": -0.23076923076923078,`

`                "Misc Defense": -0.25,`

`                "Telecom Services And Equipment": -0.2,`

`                "Abortion Policy / Pro Choice": -0.6428571428571429,`

`                "Accountants": -0.3333333333333333,`

`                "Finance / Credit Companies": -0.09090909090909091,`

`                "Misc Communications / Electronics": 0.09090909090909091,`

`                "Printing And Publishing": 0.45454545454545453,`

`                "Tobacco": 0.6363636363636364,`

`                "Pro Israel": 0.6666666666666666,`

`                "Defense Electronics": -0.7142857142857143,`

`                "Gun Rights": 0.38461538461538464,`

`                "Abortion Policy / Pro Life": 0.8823529411764706,`

`                "Environmental Svcs / Equipment": 1`

`            }`

`        }`

`    ]`

`}`

**Get industry Scores**

Gets the industry agreement scores for all legislators

`/industry_scores`

Parameters

* `industry_name`

Example

`http://api.civic-compass.org/api/v1/industry_scores.json?industry=Misc%20Unions`

Reponse

`{`

`    "legislators": [`

`        {`

`            "industry_scores": [`

`                {`

`                    "firstname": "Sherrod",`

`                    "lastname": "Brown",`

`                    "state": "OH",`

`                    "party": "Democrat",`

`                    "title": "sen",`

`                    "contributions_to_industry": 2234171,`

`                    "agreement_score_with_industry": 0.5748031496062992`

`                },`

`                {`

`                    "firstname": "Maria",`

`                    "lastname": "Cantwell",`

`                    "state": "WA",`

`                    "party": "Democrat",`

`                    "title": "sen",`

`                    "contributions_to_industry": 5000,`

`                    "agreement_score_with_industry": -0.04854368932038835`

`                },`

`                {`

`                    "firstname": "Bob",`

`                    "lastname": "Corker",`

`                    "state": "TN",`

`                    "party": "Republican",`

`                    "title": "sen",`

`                    "contributions_to_industry": 5000,`

`                    "agreement_score_with_industry": -0.46835443037974683`

`                },`

`                {`

`                    "firstname": "Dianne",`

`                    "lastname": "Feinstein",`

`                    "state": "CA",`

`                    "party": "Democrat",`

`                    "title": "sen",`

`                    "contributions_to_industry": 39800,`

`                    "agreement_score_with_industry": 0.02912621359223301`

`                },`

`                {`

`                    "firstname": "Orrin",`

`                    "lastname": "Hatch",`

`                    "state": "UT",`

`                    "party": "Republican",`

`                    "title": "sen",`

`                    "contributions_to_industry": 2000,`

`                    "agreement_score_with_industry": -0.3786407766990291`

`                }`

`            ]`

`        }`

`    ]`

`}`

**Get Influence and Ideology Scores**

Gets the influence and ideology score for a single legislator

`/influence_and_ideology_score`

Parameters

* `lastname`

* `state`

* `title`

Example

`http://api.civic-compass.org/api/v1/influence_and_ideology_score.json?lastname=Burr&state=NC&title=sen`

Reponse

`{`

`    "legislators": [`

`        {`

`            "firstname": "Richard",`

`            "lastname": "Burr",`

`            "state": "NC",`

`            "party": "Republican",`

`            "title": "sen",`

`            "ideology_rank": 70,`

`            "influence_rank": 0.1515529368351508`

`        }`

`    ]`

`}`

**Get Aggregate Influence and Ideology Scores**

Gets the influence and ideology score for all legislators

`/aggregate_influence_and_ideology_scores`

No Parameters

Example

`http://api.civic-compass.org/api/v1/aggregate_influence_and_ideology_scores.json`

Reponse

`{`

`    "legislators": [`

`        {`

`            "aggregate_influence_and_ideology_scores": [`

`                {`

`                    "firstname": "Sherrod",`

`                    "lastname": "Brown",`

`                    "state": "OH",`

`                    "party": "Democrat",`

`                    "title": "sen",`

`                    "ideology_rank": 25,`

`                    "influence_rank": 0.26759752979574586`

`                },`

`                {`

`                    "firstname": "Maria",`

`                    "lastname": "Cantwell",`

`                    "state": "WA",`

`                    "party": "Democrat",`

`                    "title": "sen",`

`                    "ideology_rank": 31,`

`                    "influence_rank": 0.12874018297738427`

`                },`

`                {`

`                    "firstname": "Bob",`

`                    "lastname": "Corker",`

`                    "state": "TN",`

`                    "party": "Republican",`

`                    "title": "sen",`

`                    "ideology_rank": 70,`

`                    "influence_rank": 0.06076091290218813`

`                },`

`                {`

`                    "firstname": "Dianne",`

`                    "lastname": "Feinstein",`

`                    "state": "CA",`

`                    "party": "Democrat",`

`                    "title": "sen",`

`                    "ideology_rank": 37,`

`                    "influence_rank": 0.04244043311942575`

`                },`

`                {`

`                    "firstname": "Orrin",`

`                    "lastname": "Hatch",`

`                    "state": "UT",`

`                    "party": "Republican",`

`                    "title": "sen",`

`                    "ideology_rank": 80,`

`                    "influence_rank": 0.2828791123162671`

`                },`

`                {`

`                    "firstname": "Amy",`

`                    "lastname": "Klobuchar",`

`                    "state": "MN",`

`                    "party": "Democrat",`

`                    "title": "sen",`

`                    "ideology_rank": 18,`

`                    "influence_rank": 0.2991495575674373`

`                }`

`            ]`

`        }`

`    ]`

`}`

