import Foundation

struct RealBoxingData {

    private static let cal = Calendar.current

    private static func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        cal.date(from: DateComponents(year: year, month: month, day: day))!
    }

    // MARK: - Real Fighters (2026 records)

    static let shakurStevenson = Fighter(id: "r_shakur", name: "Shakur Stevenson", nickname: "Fearless", record: "22-0-0", country: "🇺🇸", imageURL: nil)
    static let teofimoLopez = Fighter(id: "r_teofimo", name: "Teofimo Lopez", nickname: "The Takeover", record: "20-2-0", country: "🇺🇸", imageURL: nil)
    static let ryanGarcia = Fighter(id: "r_ryangarcia", name: "Ryan Garcia", nickname: "KingRy", record: "26-1-0", country: "🇺🇸", imageURL: nil)
    static let marioBarrios = Fighter(id: "r_barrios", name: "Mario Barrios", nickname: "El Azteca", record: "29-3-0", country: "🇺🇸", imageURL: nil)
    static let brandonFigueroa = Fighter(id: "r_figueroa", name: "Brandon Figueroa", nickname: "The Heartbreaker", record: "27-2-1", country: "🇺🇸", imageURL: nil)
    static let nickBall = Fighter(id: "r_nickball", name: "Nick Ball", nickname: "Ball", record: "23-1-1", country: "🇬🇧", imageURL: nil)
    static let emanuelNavarrete = Fighter(id: "r_navarrete", name: "Emanuel Navarrete", nickname: "Vaquero", record: "40-2-1", country: "🇲🇽", imageURL: nil)
    static let eduardoNunez = Fighter(id: "r_nunez", name: "Eduardo Nunez", nickname: "Sugar", record: "31-3-0", country: "🇲🇽", imageURL: nil)
    static let emilianoVargas = Fighter(id: "r_evargas", name: "Emiliano Vargas", nickname: "El General", record: "12-0-0", country: "🇺🇸", imageURL: nil)
    static let agustinQuintana = Fighter(id: "r_quintana", name: "Agustin Quintana", nickname: "", record: "16-6-0", country: "🇦🇷", imageURL: nil)
    static let sebastianFundora = Fighter(id: "r_fundora", name: "Sebastian Fundora", nickname: "The Towering Inferno", record: "21-1-1", country: "🇺🇸", imageURL: nil)
    static let keithThurman = Fighter(id: "r_thurman", name: "Keith Thurman", nickname: "One Time", record: "30-2-1", country: "🇺🇸", imageURL: nil)
    static let jaiOpetaia = Fighter(id: "r_opetaia", name: "Jai Opetaia", nickname: "Big Bang", record: "26-0-0", country: "🇦🇺", imageURL: nil)
    static let brandonGlanton = Fighter(id: "r_glanton", name: "Brandon Glanton", nickname: "", record: "20-2-0", country: "🇺🇸", imageURL: nil)
    static let arnoldBarboza = Fighter(id: "r_barboza", name: "Arnold Barboza Jr.", nickname: "", record: "31-0-0", country: "🇺🇸", imageURL: nil)
    static let kennethSims = Fighter(id: "r_sims", name: "Kenneth Sims Jr.", nickname: "", record: "20-3-1", country: "🇺🇸", imageURL: nil)
    static let oscarCollazo = Fighter(id: "r_collazo", name: "Oscar Collazo", nickname: "", record: "11-0-0", country: "🇵🇷", imageURL: nil)
    static let jesusHaro = Fighter(id: "r_haro", name: "Jesus Haro", nickname: "", record: "18-2-0", country: "🇲🇽", imageURL: nil)
    static let jamesDickens = Fighter(id: "r_dickens", name: "Jazza Dickens", nickname: "", record: "36-5-0", country: "🇬🇧", imageURL: nil)
    static let anthonyCacace = Fighter(id: "r_cacace", name: "Anthony Cacace", nickname: "The Apache", record: "24-1-0", country: "🇬🇧", imageURL: nil)
    static let pierceOLeary = Fighter(id: "r_oleary", name: "Pierce O'Leary", nickname: "", record: "12-0-0", country: "🇮🇪", imageURL: nil)
    static let markChamberlain = Fighter(id: "r_chamberlain", name: "Mark Chamberlain", nickname: "", record: "17-1-0", country: "🇬🇧", imageURL: nil)
    static let tysonFury = Fighter(id: "r_fury", name: "Tyson Fury", nickname: "The Gypsy King", record: "34-2-1", country: "🇬🇧", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Tyson_Fury_at_WBC_Convention_2018.jpg/440px-Tyson_Fury_at_WBC_Convention_2018.jpg")
    static let arslanbekMakhmudov = Fighter(id: "r_makhmudov", name: "Arslanbek Makhmudov", nickname: "Lion", record: "19-1-0", country: "🇷🇺", imageURL: nil)
    static let conorBenn = Fighter(id: "r_benn", name: "Conor Benn", nickname: "The Destroyer", record: "24-0-0", country: "🇬🇧", imageURL: nil)
    static let regisPrograis = Fighter(id: "r_prograis", name: "Regis Prograis", nickname: "Rougarou", record: "29-2-0", country: "🇺🇸", imageURL: nil)
    static let derekChisora = Fighter(id: "r_chisora", name: "Derek Chisora", nickname: "Del Boy", record: "35-13-0", country: "🇬🇧", imageURL: nil)
    static let deontayWilder = Fighter(id: "r_wilder", name: "Deontay Wilder", nickname: "The Bronze Bomber", record: "43-4-1", country: "🇺🇸", imageURL: nil)
    static let mosesItauma = Fighter(id: "r_itauma", name: "Moses Itauma", nickname: "", record: "12-0-0", country: "🇬🇧", imageURL: nil)
    static let jermaineFranklin = Fighter(id: "r_franklin", name: "Jermaine Franklin", nickname: "", record: "22-2-0", country: "🇺🇸", imageURL: nil)
    static let carolineDubois = Fighter(id: "r_dubois_c", name: "Caroline Dubois", nickname: "", record: "10-0-0", country: "🇬🇧", imageURL: nil)
    static let terriHarper = Fighter(id: "r_harper", name: "Terri Harper", nickname: "", record: "15-2-2", country: "🇬🇧", imageURL: nil)
    static let oleksandrUsyk = Fighter(id: "r_usyk", name: "Oleksandr Usyk", nickname: "The Cat", record: "22-0-0", country: "🇺🇦", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/2/22/Oleksandr_Usyk_2024.jpg/440px-Oleksandr_Usyk_2024.jpg")
    static let ricoVerhoeven = Fighter(id: "r_verhoeven", name: "Rico Verhoeven", nickname: "The King of Kickboxing", record: "1-0-0", country: "🇳🇱", imageURL: nil)
    static let caneloAlvarez = Fighter(id: "r_canelo", name: "Canelo Alvarez", nickname: "Canelo", record: "62-2-2", country: "🇲🇽", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/4/4f/Canelo_%C3%81lvarez_2020_%28cropped%29.jpg/440px-Canelo_%C3%81lvarez_2020_%28cropped%29.jpg")
    static let davidBenavidez = Fighter(id: "r_benavidez", name: "David Benavidez", nickname: "El Monstruo", record: "29-0-0", country: "🇺🇸", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/David_Benavidez_2024.jpg/440px-David_Benavidez_2024.jpg")
    static let zurdoRamirez = Fighter(id: "r_zurdo", name: "Gilberto Ramirez", nickname: "Zurdo", record: "46-1-0", country: "🇲🇽", imageURL: nil)
    static let frankSanchez = Fighter(id: "r_fsanchez", name: "Frank Sanchez", nickname: "The Cuban Flash", record: "25-1-0", country: "🇨🇺", imageURL: nil)
    static let richardTorrez = Fighter(id: "r_torrez", name: "Richard Torrez Jr.", nickname: "", record: "12-0-0", country: "🇺🇸", imageURL: nil)
    static let fabioWardley = Fighter(id: "r_wardley", name: "Fabio Wardley", nickname: "", record: "19-1-1", country: "🇬🇧", imageURL: nil)
    static let danielDubois = Fighter(id: "r_dubois_d", name: "Daniel Dubois", nickname: "DDD", record: "22-2-0", country: "🇬🇧", imageURL: nil)
    static let naoyaInoue = Fighter(id: "r_inoue", name: "Naoya Inoue", nickname: "Monster", record: "28-0-0", country: "🇯🇵", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/55/Naoya_Inoue_2023_%28cropped%29.jpg/440px-Naoya_Inoue_2023_%28cropped%29.jpg")
    static let gervontaDavis = Fighter(id: "r_tank", name: "Gervonta Davis", nickname: "Tank", record: "30-0-0", country: "🇺🇸", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Gervonta_Davis_2023.jpg/440px-Gervonta_Davis_2023.jpg")
    static let terenceCrawford = Fighter(id: "r_crawford", name: "Terence Crawford", nickname: "Bud", record: "41-0-0", country: "🇺🇸", imageURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5e/Terence_Crawford_2023.jpg/440px-Terence_Crawford_2023.jpg")
    static let floydMayweather = Fighter(id: "r_mayweather", name: "Floyd Mayweather", nickname: "Money", record: "50-0-0", country: "🇺🇸", imageURL: nil)
    static let mannyPacquiao = Fighter(id: "r_pacquiao", name: "Manny Pacquiao", nickname: "PacMan", record: "62-8-2", country: "🇵🇭", imageURL: nil)
    static let alexisRocha = Fighter(id: "r_rocha", name: "Alexis Rocha", nickname: "Lex", record: "25-2-0", country: "🇺🇸", imageURL: nil)
    static let josephDiaz = Fighter(id: "r_jdiaz", name: "Joseph Diaz", nickname: "JoJo", record: "33-3-1", country: "🇺🇸", imageURL: nil)
    static let tyMitchell = Fighter(id: "r_mitchell", name: "Ty Mitchell", nickname: "", record: "8-0-0", country: "🇬🇧", imageURL: nil)
    static let gabrielRosado = Fighter(id: "r_rosado", name: "Gabriel Rosado", nickname: "", record: "27-17-1", country: "🇺🇸", imageURL: nil)
    static let elleScotney = Fighter(id: "r_scotney", name: "Ellie Scotney", nickname: "", record: "9-0-0", country: "🇬🇧", imageURL: nil)
    static let mayelliFlores = Fighter(id: "r_flores", name: "Mayelli Flores", nickname: "", record: "20-0-0", country: "🇲🇽", imageURL: nil)

    // MARK: - Completed Events (Real Results)

    static let eventShakurVsTeofimo = Event(
        id: "ev_shakur_teo",
        name: "STEVENSON VS LOPEZ",
        date: date(2026, 1, 25),
        venue: "Prudential Center, Newark, NJ",
        fights: [
            Fight(id: "f_shakur_teo", fighterA: shakurStevenson, fighterB: teofimoLopez, weightClass: .superLightweight, scheduledRounds: 12, status: .completed, communityRating: 4.5, commentCount: 8_420, cardSection: .mainCard, isTitleFight: true, result: FightResult(method: "UD", scores: "117–111, 116–112, 116–112", winnerName: "Shakur Stevenson"))
        ],
        isMainEvent: true
    )

    static let eventFigueroaVsBall = Event(
        id: "ev_fig_ball",
        name: "FIGUEROA VS BALL",
        date: date(2026, 2, 7),
        venue: "M&S Bank Arena, Liverpool, England",
        fights: [
            Fight(id: "f_fig_ball", fighterA: brandonFigueroa, fighterB: nickBall, weightClass: .featherweight, scheduledRounds: 12, status: .completed, communityRating: 4.9, commentCount: 6_340, cardSection: .mainCard, isTitleFight: true, result: FightResult(method: "TKO R12", scores: nil, winnerName: "Brandon Figueroa"))
        ],
        isMainEvent: true
    )

    static let eventGarciaVsBarrios = Event(
        id: "ev_garcia_barrios",
        name: "GARCIA VS BARRIOS",
        date: date(2026, 2, 21),
        venue: "T-Mobile Arena, Las Vegas",
        fights: [
            Fight(id: "f_garcia_barrios", fighterA: ryanGarcia, fighterB: marioBarrios, weightClass: .welterweight, scheduledRounds: 12, status: .completed, communityRating: 4.7, commentCount: 12_890, cardSection: .mainCard, isTitleFight: true, result: FightResult(method: "UD", scores: "118–109, 117–110, 117–110", winnerName: "Ryan Garcia"))
        ],
        isMainEvent: true
    )

    static let eventNavarretteVsNunez = Event(
        id: "ev_nav_nunez",
        name: "NAVARRETE VS NUNEZ",
        date: date(2026, 2, 28),
        venue: "Turning Stone Resort, Verona, NY",
        fights: [
            Fight(id: "f_nav_nunez", fighterA: emanuelNavarrete, fighterB: eduardoNunez, weightClass: .superLightweight, scheduledRounds: 12, status: .completed, communityRating: 4.4, commentCount: 3_120, cardSection: .mainCard, isTitleFight: true, result: FightResult(method: "TKO R11", scores: nil, winnerName: "Emanuel Navarrete")),
            Fight(id: "f_vargas_quint", fighterA: emilianoVargas, fighterB: agustinQuintana, weightClass: .superLightweight, scheduledRounds: 10, status: .completed, communityRating: 4.2, commentCount: 1_560, cardSection: .undercard, result: FightResult(method: "TKO R9", scores: nil, winnerName: "Emiliano Vargas"))
        ],
        isMainEvent: false
    )

    // MARK: - This Week (March 3-9, 2026)

    static let eventMitchellVsRosado = Event(
        id: "ev_mitchell_rosado",
        name: "MISFITS DUEL 2",
        date: date(2026, 3, 7),
        venue: "Derby Arena, Derby, England",
        fights: [
            Fight(id: "f_mitchell_rosado", fighterA: tyMitchell, fighterB: gabrielRosado, weightClass: .lightHeavyweight, scheduledRounds: 8, status: .upcoming, communityRating: 3.2, commentCount: 890, cardSection: .mainCard, startTime: date(2026, 3, 7).addingTimeInterval(72000))
        ],
        isMainEvent: false
    )

    static let eventOpetaiaVsGlanton = Event(
        id: "ev_opetaia_glanton",
        name: "OPETAIA VS GLANTON",
        date: date(2026, 3, 8),
        venue: "MGM Grand, Las Vegas",
        fights: [
            Fight(id: "f_opetaia_glanton", fighterA: jaiOpetaia, fighterB: brandonGlanton, weightClass: .cruiserweight, scheduledRounds: 12, status: .upcoming, communityRating: 4.3, commentCount: 2_780, cardSection: .mainCard, isTitleFight: true, startTime: date(2026, 3, 8).addingTimeInterval(72000))
        ],
        isMainEvent: true
    )

    // MARK: - March 14, 2026

    static let eventDublinCard = Event(
        id: "ev_dublin_mar14",
        name: "DUBLIN FIGHT NIGHT",
        date: date(2026, 3, 14),
        venue: "3Arena, Dublin, Ireland",
        fights: [
            Fight(id: "f_dickens_cacace", fighterA: jamesDickens, fighterB: anthonyCacace, weightClass: .superLightweight, scheduledRounds: 12, status: .upcoming, communityRating: 4.1, commentCount: 1_890, cardSection: .mainCard, isTitleFight: true, startTime: date(2026, 3, 14).addingTimeInterval(72000)),
            Fight(id: "f_oleary_chamb", fighterA: pierceOLeary, fighterB: markChamberlain, weightClass: .superLightweight, scheduledRounds: 12, status: .upcoming, communityRating: 4.4, commentCount: 2_340, cardSection: .mainCard, startTime: date(2026, 3, 14).addingTimeInterval(68400))
        ],
        isMainEvent: false
    )

    static let eventAnaheimCard = Event(
        id: "ev_anaheim_mar14",
        name: "GOLDEN BOY FIGHT NIGHT",
        date: date(2026, 3, 14),
        venue: "Honda Center, Anaheim, CA",
        fights: [
            Fight(id: "f_barboza_sims", fighterA: arnoldBarboza, fighterB: kennethSims, weightClass: .welterweight, scheduledRounds: 12, status: .upcoming, communityRating: 4.0, commentCount: 1_450, cardSection: .mainCard, startTime: date(2026, 3, 14).addingTimeInterval(75600)),
            Fight(id: "f_collazo_haro", fighterA: oscarCollazo, fighterB: jesusHaro, weightClass: .lightweight, scheduledRounds: 12, status: .upcoming, communityRating: 3.8, commentCount: 980, cardSection: .undercard, isTitleFight: true, startTime: date(2026, 3, 14).addingTimeInterval(72000)),
            Fight(id: "f_rocha_diaz", fighterA: alexisRocha, fighterB: josephDiaz, weightClass: .welterweight, scheduledRounds: 10, status: .upcoming, communityRating: 3.9, commentCount: 1_120, cardSection: .undercard, startTime: date(2026, 3, 14).addingTimeInterval(68400))
        ],
        isMainEvent: false
    )

    // MARK: - March 28, 2026

    static let eventFundoraVsThurman = Event(
        id: "ev_fundora_thurman",
        name: "FUNDORA VS THURMAN",
        date: date(2026, 3, 28),
        venue: "MGM Grand Garden Arena, Las Vegas",
        fights: [
            Fight(id: "f_fundora_thurman", fighterA: sebastianFundora, fighterB: keithThurman, weightClass: .superWelterweight, scheduledRounds: 12, status: .upcoming, communityRating: 4.6, commentCount: 7_890, cardSection: .mainCard, isTitleFight: true, startTime: date(2026, 3, 28).addingTimeInterval(75600)),
            Fight(id: "f_sanchez_torrez", fighterA: frankSanchez, fighterB: richardTorrez, weightClass: .heavyweight, scheduledRounds: 12, status: .upcoming, communityRating: 4.1, commentCount: 2_340, cardSection: .mainCard, startTime: date(2026, 3, 28).addingTimeInterval(72000)),
            Fight(id: "f_itauma_franklin", fighterA: mosesItauma, fighterB: jermaineFranklin, weightClass: .heavyweight, scheduledRounds: 10, status: .upcoming, communityRating: 4.3, commentCount: 3_120, cardSection: .undercard, startTime: date(2026, 3, 28).addingTimeInterval(68400))
        ],
        isMainEvent: true
    )

    // MARK: - April 4-5, 2026

    static let eventO2London = Event(
        id: "ev_o2_apr4",
        name: "CHISORA VS WILDER",
        date: date(2026, 4, 4),
        venue: "O2 Arena, London",
        fights: [
            Fight(id: "f_chisora_wilder", fighterA: derekChisora, fighterB: deontayWilder, weightClass: .heavyweight, scheduledRounds: 12, status: .upcoming, communityRating: 4.2, commentCount: 5_670, cardSection: .mainCard, startTime: date(2026, 4, 4).addingTimeInterval(72000))
        ],
        isMainEvent: false
    )

    static let eventOlympia = Event(
        id: "ev_olympia_apr5",
        name: "QUEENS OF THE RING",
        date: date(2026, 4, 5),
        venue: "Olympia, London",
        fights: [
            Fight(id: "f_dubois_harper", fighterA: carolineDubois, fighterB: terriHarper, weightClass: .lightweight, scheduledRounds: 10, status: .upcoming, communityRating: 4.5, commentCount: 4_230, cardSection: .mainCard, isTitleFight: true, startTime: date(2026, 4, 5).addingTimeInterval(72000)),
            Fight(id: "f_scotney_flores", fighterA: elleScotney, fighterB: mayelliFlores, weightClass: .bantamweight, scheduledRounds: 10, status: .upcoming, communityRating: 4.3, commentCount: 2_890, cardSection: .mainCard, isTitleFight: true, startTime: date(2026, 4, 5).addingTimeInterval(68400))
        ],
        isMainEvent: true
    )

    // MARK: - April 11, 2026

    static let eventTottenham = Event(
        id: "ev_tottenham_apr11",
        name: "FURY VS MAKHMUDOV",
        date: date(2026, 4, 11),
        venue: "Tottenham Hotspur Stadium, London",
        fights: [
            Fight(id: "f_fury_makhmudov", fighterA: tysonFury, fighterB: arslanbekMakhmudov, weightClass: .heavyweight, scheduledRounds: 12, status: .upcoming, communityRating: 4.4, commentCount: 14_560, cardSection: .mainCard, startTime: date(2026, 4, 11).addingTimeInterval(72000)),
            Fight(id: "f_benn_prograis", fighterA: conorBenn, fighterB: regisPrograis, weightClass: .welterweight, scheduledRounds: 12, status: .upcoming, communityRating: 4.5, commentCount: 6_890, cardSection: .mainCard, startTime: date(2026, 4, 11).addingTimeInterval(68400))
        ],
        isMainEvent: true
    )

    // MARK: - May 2, 2026

    static let eventRamirezVsBenavidez = Event(
        id: "ev_zurdo_benavidez",
        name: "RAMIREZ VS BENAVIDEZ",
        date: date(2026, 5, 2),
        venue: "T-Mobile Arena, Las Vegas",
        fights: [
            Fight(id: "f_zurdo_benavidez", fighterA: zurdoRamirez, fighterB: davidBenavidez, weightClass: .cruiserweight, scheduledRounds: 12, status: .upcoming, communityRating: 4.8, commentCount: 9_340, cardSection: .mainCard, isTitleFight: true, startTime: date(2026, 5, 2).addingTimeInterval(75600))
        ],
        isMainEvent: true
    )

    // MARK: - May 9, 2026

    static let eventWardleyVsDubois = Event(
        id: "ev_wardley_dubois",
        name: "WARDLEY VS DUBOIS",
        date: date(2026, 5, 9),
        venue: "AO Arena, Manchester, England",
        fights: [
            Fight(id: "f_wardley_dubois", fighterA: fabioWardley, fighterB: danielDubois, weightClass: .heavyweight, scheduledRounds: 12, status: .upcoming, communityRating: 4.3, commentCount: 5_120, cardSection: .mainCard, isTitleFight: true, startTime: date(2026, 5, 9).addingTimeInterval(72000))
        ],
        isMainEvent: true
    )

    // MARK: - May 23, 2026

    static let eventUsykVsVerhoeven = Event(
        id: "ev_usyk_verhoeven",
        name: "USYK VS VERHOEVEN",
        date: date(2026, 5, 23),
        venue: "Giza Pyramids, Egypt",
        fights: [
            Fight(id: "f_usyk_verhoeven", fighterA: oleksandrUsyk, fighterB: ricoVerhoeven, weightClass: .heavyweight, scheduledRounds: 12, status: .upcoming, communityRating: 4.6, commentCount: 18_790, cardSection: .mainCard, isTitleFight: true, startTime: date(2026, 5, 23).addingTimeInterval(72000))
        ],
        isMainEvent: true
    )

    // MARK: - September 19, 2026

    static let eventMayweatherVsPacquiao = Event(
        id: "ev_money_pac",
        name: "MAYWEATHER VS PACQUIAO II",
        date: date(2026, 9, 19),
        venue: "Las Vegas",
        fights: [
            Fight(id: "f_money_pac", fighterA: floydMayweather, fighterB: mannyPacquiao, weightClass: .welterweight, scheduledRounds: 12, status: .upcoming, communityRating: 4.9, commentCount: 45_670, cardSection: .mainCard, startTime: date(2026, 9, 19).addingTimeInterval(75600))
        ],
        isMainEvent: true
    )

    // MARK: - All Events

    static let allEvents: [Event] = [
        eventShakurVsTeofimo,
        eventFigueroaVsBall,
        eventGarciaVsBarrios,
        eventNavarretteVsNunez,
        eventMitchellVsRosado,
        eventOpetaiaVsGlanton,
        eventDublinCard,
        eventAnaheimCard,
        eventFundoraVsThurman,
        eventO2London,
        eventOlympia,
        eventTottenham,
        eventRamirezVsBenavidez,
        eventWardleyVsDubois,
        eventUsykVsVerhoeven,
        eventMayweatherVsPacquiao,
    ].sorted { $0.date < $1.date }

    // MARK: - Fighter Highlights

    static let fighterHighlights: [String: FighterHighlight] = {
        var highlights: [String: FighterHighlight] = [:]
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())

        highlights[formatDate(date(2026, 2, 28))] = FighterHighlight(fighter: emanuelNavarrete, grade: 9.1, fightContext: "vs Eduardo Nunez · TKO R11")
        highlights[formatDate(date(2026, 2, 21))] = FighterHighlight(fighter: ryanGarcia, grade: 9.4, fightContext: "vs Mario Barrios · WBC Title Win")
        highlights[formatDate(date(2026, 2, 7))] = FighterHighlight(fighter: brandonFigueroa, grade: 9.7, fightContext: "vs Nick Ball · TKO R12 Upset")
        highlights[formatDate(date(2026, 1, 25))] = FighterHighlight(fighter: shakurStevenson, grade: 8.8, fightContext: "vs Teofimo Lopez · WBO Title")

        let todayStr = formatDate(today)
        if highlights[todayStr] == nil {
            highlights[todayStr] = FighterHighlight(fighter: ryanGarcia, grade: 9.4, fightContext: "WBC Welterweight Champion · Dominated Barrios")
        }

        return highlights
    }()

    private static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    static func highlightForDate(_ date: Date) -> FighterHighlight? {
        let key = formatDate(date)
        if let exact = fighterHighlights[key] { return exact }

        let cal = Calendar.current
        for offset in [-1, 1, -2, 2] {
            if let nearby = cal.date(byAdding: .day, value: offset, to: date) {
                let nearbyKey = formatDate(nearby)
                if let highlight = fighterHighlights[nearbyKey] { return highlight }
            }
        }

        let allCompleted = allEvents.filter { $0.fights.first?.status == .completed }
        if let latest = allCompleted.last, let mainFight = latest.fights.first {
            let winner = mainFight.result?.winnerName ?? mainFight.fighterA.name
            let fighter = mainFight.fighterA.name == winner ? mainFight.fighterA : mainFight.fighterB
            return FighterHighlight(fighter: fighter, grade: mainFight.communityRating * 2, fightContext: "\(mainFight.fighterA.name) vs \(mainFight.fighterB.name)")
        }

        return nil
    }

    static func highlightForWeek(startOfWeek: Date) -> FighterHighlight? {
        let cal = Calendar.current
        let weekEnd = cal.date(byAdding: .day, value: 6, to: startOfWeek) ?? startOfWeek

        var bestHighlight: FighterHighlight?
        var bestGrade: Double = -1

        for dayOffset in 0...6 {
            guard let day = cal.date(byAdding: .day, value: dayOffset, to: startOfWeek) else { continue }
            let key = formatDate(day)
            if let highlight = fighterHighlights[key], highlight.grade > bestGrade {
                bestGrade = highlight.grade
                bestHighlight = highlight
            }
        }

        if let highlight = bestHighlight { return highlight }

        let weekEvents = allEvents.filter { event in
            let eventDay = cal.startOfDay(for: event.date)
            return eventDay >= startOfWeek && eventDay <= weekEnd
        }

        let completedFights = weekEvents.flatMap(\.fights).filter { $0.status == .completed }
        if let topFight = completedFights.max(by: { $0.communityRating < $1.communityRating }) {
            let winner = topFight.result?.winnerName ?? topFight.fighterA.name
            let fighter = topFight.fighterA.name == winner ? topFight.fighterA : topFight.fighterB
            return FighterHighlight(fighter: fighter, grade: topFight.communityRating * 2, fightContext: "\(topFight.fighterA.name) vs \(topFight.fighterB.name)")
        }

        let upcomingFights = weekEvents.flatMap(\.fights).filter { $0.status == .upcoming }
        if let topUpcoming = upcomingFights.max(by: { $0.commentCount < $1.commentCount }) {
            return FighterHighlight(fighter: topUpcoming.fighterA, grade: topUpcoming.communityRating * 2, fightContext: "vs \(topUpcoming.fighterB.name) · \(topUpcoming.weightClass.rawValue)")
        }

        return highlightForDate(startOfWeek)
    }

    // MARK: - Community Posts

    static let samplePosts: [Post] = [
        Post(id: "rp1", userName: "BoxingFanatic99", userHandle: "@boxfan99", avatarEmoji: "🥊", badges: ["Analyst"], fightContext: "Garcia vs Barrios", text: "Ryan Garcia just silenced every doubter. 82 jabs landed — most ever against Barrios. That's not just a win, that's a statement. KingRy is for real.", likes: 1_243, comments: 89, timestamp: Date().addingTimeInterval(-7200), isLiked: false),
        Post(id: "rp2", userName: "RingSideKing", userHandle: "@ringsideking", avatarEmoji: "👑", badges: ["Scout", "Analyst"], fightContext: "Figueroa vs Ball", text: "Figueroa traveling to Liverpool and stopping Ball in the 12th is the upset of the year so far. Ball was ahead on all cards — one left hook changed everything. That's boxing.", likes: 892, comments: 67, timestamp: Date().addingTimeInterval(-86400), isLiked: true),
        Post(id: "rp3", userName: "FightNightMike", userHandle: "@fightmike", avatarEmoji: "🔥", badges: ["Matchmaker"], fightContext: "Fundora vs Thurman", text: "Fundora vs Thurman on March 28 at MGM Grand is going to be WILD. Fundora's 6'5\" frame vs Thurman's speed and power. Classic styles clash. My money's on Fundora by late stoppage.", likes: 567, comments: 45, timestamp: Date().addingTimeInterval(-14400), isLiked: false),
        Post(id: "rp4", userName: "UndercardHunter", userHandle: "@undercardh", avatarEmoji: "🔍", badges: ["Hunter"], fightContext: nil, text: "Keep your eyes on Emiliano Vargas (12-0). Stopped Quintana in round 9 last week. At only 21, this kid is special. Future champion material. Mark my words.", likes: 345, comments: 23, timestamp: Date().addingTimeInterval(-28800), isLiked: false),
        Post(id: "rp5", userName: "HeavyweightWatch", userHandle: "@hwwatch", avatarEmoji: "💪", badges: ["Analyst"], fightContext: "Fury vs Makhmudov", text: "Fury returning April 11 at Tottenham Hotspur Stadium vs Makhmudov. Is this the start of Fury's final chapter? Makhmudov hits HARD but hasn't faced elite competition. Fury by mid-rounds KO.", likes: 1_567, comments: 134, timestamp: Date().addingTimeInterval(-43200), isLiked: true),
        Post(id: "rp6", userName: "WomenBoxingFan", userHandle: "@womenboxing", avatarEmoji: "⭐", badges: ["Scout"], fightContext: "Dubois vs Harper", text: "April 5 at Olympia is the biggest women's boxing card of the year. Dubois vs Harper for the lightweight belts PLUS Scotney going undisputed. Women's boxing is thriving. 🔥", likes: 789, comments: 56, timestamp: Date().addingTimeInterval(-57600), isLiked: false),
        Post(id: "rp7", userName: "BoxingHistorian", userHandle: "@boxhistory", avatarEmoji: "📚", badges: ["Veteran"], fightContext: "Mayweather vs Pacquiao II", text: "Mayweather vs Pacquiao II in September?! They're both in their 40s but this is going to break PPV records regardless. The nostalgia factor alone is worth the price. Who's buying?", likes: 2_340, comments: 287, timestamp: Date().addingTimeInterval(-72000), isLiked: true),
        Post(id: "rp8", userName: "ScoreCardPro", userHandle: "@scorecardpro", avatarEmoji: "📝", badges: ["Analyst", "Matchmaker"], fightContext: "Stevenson vs Lopez", text: "Shakur made Teofimo look average. 117-111 was the right score. Stevenson's defense is generational — Teofimo landed maybe 20% of his power shots. Boring to casuals, masterclass to students of the game.", likes: 678, comments: 78, timestamp: Date().addingTimeInterval(-172800), isLiked: false),
    ]

    // MARK: - Interactions

    static func interactionsForFights() -> [String: FightInteraction] {
        var interactions: [String: FightInteraction] = [:]

        let allFights = allEvents.flatMap(\.fights)
        let ratedFights: [String: (Double, String)] = [
            "f_shakur_teo": (8.2, "Shakur's defense was a masterclass. Teofimo couldn't find him."),
            "f_fig_ball": (9.5, "UPSET OF THE YEAR! Figueroa's left hook in the 12th was devastating."),
            "f_garcia_barrios": (8.8, "Garcia proved the doubters wrong. Dominant performance."),
            "f_nav_nunez": (7.9, "Navarrete's pressure was too much. Nunez showed heart though."),
        ]

        for fight in allFights {
            let rated = ratedFights[fight.id]
            let sampleComments: [FightComment] = [
                FightComment(id: "fc_\(fight.id)_1", userName: "BoxingFanatic99", avatarEmoji: "🥊", text: "Great matchup!", timestamp: Date().addingTimeInterval(-3600)),
                FightComment(id: "fc_\(fight.id)_2", userName: "RingSideKing", avatarEmoji: "👑", text: "Can't wait to see how this plays out", timestamp: Date().addingTimeInterval(-1800)),
                FightComment(id: "fc_\(fight.id)_3", userName: "FightNightMike", avatarEmoji: "🔥", text: "This is going to be fire", timestamp: Date().addingTimeInterval(-900)),
            ]

            interactions[fight.id] = FightInteraction(
                id: "int_\(fight.id)",
                fightId: fight.id,
                userRating: rated?.0,
                userComment: rated?.1,
                thumbsUp: Int.random(in: 45...890),
                thumbsDown: Int.random(in: 5...65),
                hasThumbedUp: false,
                hasThumbedDown: false,
                communityComments: sampleComments
            )
        }

        return interactions
    }
}
