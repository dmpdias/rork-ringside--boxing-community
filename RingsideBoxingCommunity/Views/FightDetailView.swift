import SwiftUI

struct FightDetailView: View {
    let fight: Fight
    @State private var vm: FightDetailViewModel

    init(fight: Fight) {
        self.fight = fight
        self._vm = State(wrappedValue: FightDetailViewModel(fight: fight))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroHeader
                    .padding(.bottom, 20)

                VStack(spacing: 20) {
                    liveResultBlock
                    overallRatingBlock
                    roundByRoundStrip
                    actionsRow
                    discussionCarousel
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 40)
        }
        .scrollIndicators(.hidden)
        .background(MeshBackgroundView())
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(fight.weightClass.rawValue.uppercased())
                    .font(.system(.caption, weight: .bold).width(.compressed))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
        .sheet(isPresented: $vm.showRoundRatingSheet) {
            roundRatingSheet
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $vm.showPredictionSheet) {
            predictionSheet
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $vm.showDiscussionModal) {
            discussionModal
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Hero Header

    private var heroHeader: some View {
        VStack(spacing: 0) {
            VStack(spacing: 4) {
                Text(eventNameForFight.uppercased())
                    .font(.system(size: 20, weight: .heavy, design: .default).width(.compressed))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)

                Text(eventSubtitle)
                    .font(.system(.caption2, weight: .medium))
                    .foregroundStyle(.white.opacity(0.35))
            }
            .padding(.top, 4)

            HStack(alignment: .center, spacing: 0) {
                fighterColumn(fighter: fight.fighterA)
                centerVS
                fighterColumn(fighter: fight.fighterB)
            }
            .padding(.top, 12)
        }
    }

    private func fighterColumn(fighter: Fighter) -> some View {
        VStack(spacing: 10) {
            if let urlString = fighter.imageURL, let url = URL(string: urlString) {
                Color.clear
                    .frame(width: 130, height: 180)
                    .overlay {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable().aspectRatio(contentMode: .fill)
                            case .failure:
                                fighterPlaceholder
                            case .empty:
                                ProgressView().tint(.white.opacity(0.3))
                            @unknown default:
                                fighterPlaceholder
                            }
                        }
                        .allowsHitTesting(false)
                    }
                    .clipShape(.rect(cornerRadius: 16))
                    .overlay(
                        LinearGradient(
                            colors: [.clear, .clear, RingsideTheme.deepBackground.opacity(0.85)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .clipShape(.rect(cornerRadius: 16))
                    )
                    .overlay(alignment: .bottom) {
                        Text(fighter.country)
                            .font(.title3)
                            .padding(.bottom, 6)
                    }
            } else {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.06), Color.white.opacity(0.02)],
                            startPoint: .top, endPoint: .bottom
                        )
                    )
                    .frame(width: 130, height: 180)
                    .overlay {
                        VStack(spacing: 8) {
                            Image(systemName: "figure.boxing")
                                .font(.system(size: 48))
                                .foregroundStyle(.white.opacity(0.12))
                            Text(fighter.country)
                                .font(.title3)
                        }
                    }
            }

            VStack(spacing: 2) {
                Text(fighter.name.components(separatedBy: " ").last ?? "")
                    .font(.system(.subheadline, weight: .heavy).width(.compressed))
                    .foregroundStyle(.white)
                Text(fighter.record)
                    .font(.system(.caption2, weight: .medium))
                    .foregroundStyle(.white.opacity(0.35))
                if !fighter.nickname.isEmpty {
                    Text("\"\(fighter.nickname)\"")
                        .font(.system(.caption2, weight: .medium).italic())
                        .foregroundStyle(RingsideTheme.gold.opacity(0.5))
                }
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var centerVS: some View {
        VStack(spacing: 8) {
            if fight.status == .live {
                HStack(spacing: 4) {
                    LiveDot()
                    Text("RD \(fight.currentRound ?? 1)/\(fight.scheduledRounds)")
                        .font(.system(.caption2, weight: .bold).width(.compressed))
                        .foregroundStyle(RingsideTheme.liveRed)
                }
            }

            Text("VS")
                .font(.system(size: 32, weight: .black, design: .default).width(.compressed))
                .foregroundStyle(RingsideTheme.gold)
                .tracking(4)

            statusLabel

            VStack(spacing: 2) {
                Text(fight.weightClass.rawValue.uppercased())
                    .font(.system(.caption2, weight: .bold).width(.compressed))
                    .foregroundStyle(RingsideTheme.gold.opacity(0.45))
                Text("\(fight.scheduledRounds) RDS")
                    .font(.system(size: 9, weight: .semibold).width(.compressed))
                    .foregroundStyle(.white.opacity(0.2))
            }
            .padding(.top, 2)
        }
        .frame(width: 80)
    }

    private var fighterPlaceholder: some View {
        ZStack {
            Color.white.opacity(0.04)
            Image(systemName: "figure.boxing")
                .font(.system(size: 48))
                .foregroundStyle(.white.opacity(0.1))
        }
    }

    @ViewBuilder
    private var statusLabel: some View {
        switch fight.status {
        case .live:
            Text("LIVE")
                .font(.system(.caption2, weight: .bold))
                .foregroundStyle(RingsideTheme.liveRed)
        case .upcoming:
            Text(fight.date?.formatted(.dateTime.month(.abbreviated).day()) ?? "TBD")
                .font(.system(.caption2, weight: .bold))
                .foregroundStyle(.white.opacity(0.35))
        case .completed:
            Text("FINAL")
                .font(.system(.caption2, weight: .bold))
                .foregroundStyle(RingsideTheme.gold)
        }
    }

    // MARK: - 1. Live Result Block

    private var liveResultBlock: some View {
        VStack(spacing: 0) {
            sectionLabel(icon: "bolt.fill", title: phaseLabel)
                .padding(.bottom, 12)

            VStack(spacing: 10) {
                switch vm.phase {
                case .pre:
                    preResultContent
                case .live:
                    liveResultContent
                case .post:
                    postResultContent
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .clipShape(.rect(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(resultBorderGradient, lineWidth: 0.5)
            )
            .shadow(color: resultShadowColor, radius: 16, y: 6)
        }
    }

    private var phaseLabel: String {
        switch vm.phase {
        case .pre: return "UPCOMING"
        case .live: return "LIVE STATUS"
        case .post: return "RESULT"
        }
    }

    private var resultBorderGradient: LinearGradient {
        switch vm.phase {
        case .live:
            return LinearGradient(
                colors: [RingsideTheme.liveRed.opacity(0.4), Color.white.opacity(0.08)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        case .post:
            return LinearGradient(
                colors: [RingsideTheme.gold.opacity(0.3), Color.white.opacity(0.06)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                colors: [Color.white.opacity(0.12), Color.white.opacity(0.04)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
        }
    }

    private var resultShadowColor: Color {
        switch vm.phase {
        case .live: return RingsideTheme.liveRed.opacity(0.1)
        case .post: return RingsideTheme.gold.opacity(0.06)
        default: return .black.opacity(0.15)
        }
    }

    private var preResultContent: some View {
        VStack(spacing: 12) {
            HStack(spacing: 6) {
                if let countdown = vm.countdownText {
                    HStack(spacing: 5) {
                        Image(systemName: "clock.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(RingsideTheme.gold.opacity(0.7))
                        Text(countdown)
                            .font(.system(.subheadline, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                }
                if fight.isTitleFight {
                    Text("·")
                        .foregroundStyle(.white.opacity(0.2))
                    HStack(spacing: 4) {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 10))
                        Text("Title Fight")
                            .font(.system(.caption, weight: .bold))
                    }
                    .foregroundStyle(RingsideTheme.gold)
                }
            }

            if vm.hasPredicted {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(.green)
                        .font(.subheadline)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Your Prediction")
                            .font(.system(.caption2, weight: .bold))
                            .foregroundStyle(.green.opacity(0.7))
                        Text("\(vm.predictedWinner ?? "") · \(vm.predictedMethod?.rawValue ?? "") · Rds \(vm.predictedRoundRange ?? "")")
                            .font(.system(.caption, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    Spacer()
                }
                .padding(12)
                .background(Color.green.opacity(0.06))
                .clipShape(.rect(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(Color.green.opacity(0.15), lineWidth: 0.5)
                )
            } else {
                Button {
                    vm.showPredictionSheet = true
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "chart.bar.fill")
                            .font(.caption)
                        Text("MAKE YOUR PREDICTION")
                            .font(.system(.caption, weight: .bold).width(.compressed))
                    }
                    .foregroundStyle(RingsideTheme.gold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(RingsideTheme.gold.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(RingsideTheme.gold.opacity(0.25), lineWidth: 0.5)
                    )
                }
            }
        }
    }

    private var liveResultContent: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                LiveDot()
                Text("ROUND \(fight.currentRound ?? 1) OF \(fight.scheduledRounds)")
                    .font(.system(.title3, weight: .black).width(.compressed))
                    .foregroundStyle(.white)
            }

            if let score = vm.unofficialScore {
                HStack(spacing: 6) {
                    Image(systemName: "person.crop.rectangle.stack")
                        .font(.system(size: 10))
                    Text("Unofficial: \(score)")
                        .font(.system(.caption, weight: .medium).italic())
                }
                .foregroundStyle(.white.opacity(0.45))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.04))
                .clipShape(.rect(cornerRadius: 8))
            }
        }
    }

    private var postResultContent: some View {
        VStack(spacing: 8) {
            if let result = fight.result {
                Text(result.method)
                    .font(.system(.title2, weight: .black).width(.compressed))
                    .foregroundStyle(.white)

                if let scores = result.scores {
                    Text(scores)
                        .font(.system(.caption, weight: .medium))
                        .foregroundStyle(.white.opacity(0.45))
                }

                if let winner = result.winnerName {
                    HStack(spacing: 6) {
                        Image(systemName: "crown.fill")
                            .font(.caption)
                            .foregroundStyle(RingsideTheme.gold)
                        Text(winner)
                            .font(.system(.subheadline, weight: .bold))
                            .foregroundStyle(RingsideTheme.gold)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(RingsideTheme.gold.opacity(0.08))
                    .clipShape(.rect(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .strokeBorder(RingsideTheme.gold.opacity(0.2), lineWidth: 0.5)
                    )
                }
            } else {
                Text("FINAL")
                    .font(.system(.title2, weight: .black))
                    .foregroundStyle(RingsideTheme.gold)
            }
        }
    }

    // MARK: - 2. Overall Rating Block

    private var overallRatingBlock: some View {
        VStack(spacing: 0) {
            HStack {
                sectionLabel(icon: "star.fill", title: "YOUR RATING")
                Spacer()
                if vm.phase == .live && !vm.hasRatedOverall {
                    Text("Set after the final bell")
                        .font(.system(.caption2, weight: .medium).italic())
                        .foregroundStyle(.white.opacity(0.2))
                }
                if vm.hasRatedOverall {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption2)
                            .foregroundStyle(.green)
                        Text("Rated")
                            .font(.caption2)
                            .foregroundStyle(.green.opacity(0.8))
                    }
                }
            }
            .padding(.bottom, 12)

            VStack(spacing: 16) {
                if vm.overallRating > 0 {
                    Text(String(format: "%.1f", vm.overallRating))
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundStyle(RingsideTheme.gold)
                        .contentTransition(.numericText())
                        .padding(.top, 4)
                }

                ratingButtons
                ratingSlider
                tagChips
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .clipShape(.rect(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [RingsideTheme.gold.opacity(0.25), RingsideTheme.gold.opacity(0.04)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            )
            .shadow(color: RingsideTheme.gold.opacity(0.06), radius: 14, y: 6)
            .opacity(vm.phase == .live ? 0.7 : 1.0)
        }
    }

    private var ratingButtons: some View {
        HStack(spacing: 0) {
            ForEach([2.0, 4.0, 6.0, 8.0, 10.0], id: \.self) { value in
                Button {
                    withAnimation(.bouncy) {
                        vm.overallRating = vm.overallRating == value ? 0 : value
                    }
                } label: {
                    let isActive = vm.overallRating >= value
                    Text(String(format: "%.0f", value))
                        .font(.system(.subheadline, weight: .heavy))
                        .foregroundStyle(isActive ? RingsideTheme.gold : .white.opacity(0.18))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(isActive ? RingsideTheme.gold.opacity(0.12) : Color.white.opacity(0.03))
                }
                .sensoryFeedback(.impact(weight: .light), trigger: vm.overallRating)

                if value < 10 {
                    Rectangle()
                        .fill(Color.white.opacity(0.04))
                        .frame(width: 0.5)
                }
            }
        }
        .clipShape(.rect(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(Color.white.opacity(0.06), lineWidth: 0.5)
        )
    }

    private var ratingSlider: some View {
        VStack(spacing: 4) {
            Slider(value: $vm.overallRating, in: 0...10, step: 0.1)
                .tint(RingsideTheme.gold)
            HStack {
                Text("0")
                Spacer()
                Text("10")
            }
            .font(.system(size: 9, weight: .medium))
            .foregroundStyle(.white.opacity(0.15))
        }
    }

    private var tagChips: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(FightTag.allCases, id: \.rawValue) { tag in
                    Button {
                        withAnimation(.snappy) {
                            if vm.selectedTags.contains(tag) {
                                vm.selectedTags.remove(tag)
                            } else {
                                vm.selectedTags.insert(tag)
                            }
                        }
                    } label: {
                        let isActive = vm.selectedTags.contains(tag)
                        Text(tag.rawValue)
                            .font(.system(.caption2, weight: .bold))
                            .foregroundStyle(isActive ? .black : .white.opacity(0.45))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(isActive ? RingsideTheme.gold : Color.white.opacity(0.05))
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .strokeBorder(isActive ? Color.clear : Color.white.opacity(0.06), lineWidth: 0.5)
                            )
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - 3. Round-by-Round Strip

    private var roundByRoundStrip: some View {
        VStack(spacing: 0) {
            HStack {
                sectionLabel(icon: "list.number", title: "ROUND-BY-ROUND")
                Spacer()
                Text("\(vm.scoredRoundCount)/\(fight.scheduledRounds) scored")
                    .font(.system(.caption2, weight: .medium))
                    .foregroundStyle(.white.opacity(0.25))
            }
            .padding(.bottom, 12)

            VStack(spacing: 14) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(1...fight.scheduledRounds, id: \.self) { round in
                            roundPill(round)
                        }
                    }
                }
                .contentMargins(.horizontal, 0)

                Button {
                    if vm.scoredRoundCount > 0 {
                        let nextUnscoredRound = (1...fight.scheduledRounds).first { vm.roundRatings[$0] == nil && vm.isRoundTappable($0) }
                        if let round = nextUnscoredRound {
                            vm.openRoundRating(round)
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: vm.canSaveCard ? "checkmark.circle.fill" : "pencil.circle.fill")
                            .font(.caption)
                        Text(vm.cardButtonLabel.uppercased())
                            .font(.system(.caption, weight: .bold).width(.compressed))
                    }
                    .foregroundStyle(vm.canSaveCard ? .black : RingsideTheme.gold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(vm.canSaveCard ? RingsideTheme.gold : RingsideTheme.gold.opacity(0.1))
                    .clipShape(.rect(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(
                                vm.canSaveCard ? Color.clear : RingsideTheme.gold.opacity(0.2),
                                lineWidth: 0.5
                            )
                    )
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.ultraThinMaterial)
            )
            .clipShape(.rect(cornerRadius: 18, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [Color.white.opacity(0.1), Color.white.opacity(0.03)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            )
            .shadow(color: .black.opacity(0.15), radius: 12, y: 6)
        }
    }

    private func roundPill(_ round: Int) -> some View {
        let tappable = vm.isRoundTappable(round)
        let hasRating = vm.roundRatings[round] != nil
        let score = vm.roundRatings[round]?.score

        return Button {
            guard tappable else { return }
            vm.openRoundRating(round)
        } label: {
            VStack(spacing: 3) {
                Text("R\(round)")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(tappable ? .white.opacity(0.7) : .white.opacity(0.15))

                if let s = score {
                    Text(String(format: "%.0f", s))
                        .font(.system(.caption, weight: .black))
                        .foregroundStyle(RingsideTheme.gold)
                } else {
                    Text("–")
                        .font(.system(.caption, weight: .medium))
                        .foregroundStyle(.white.opacity(0.12))
                }
            }
            .frame(width: 42, height: 50)
            .background(
                hasRating
                    ? RingsideTheme.gold.opacity(0.1)
                    : Color.white.opacity(tappable ? 0.04 : 0.015)
            )
            .clipShape(.rect(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(
                        hasRating
                            ? RingsideTheme.gold.opacity(0.3)
                            : Color.white.opacity(tappable ? 0.06 : 0.02),
                        lineWidth: 0.5
                    )
            )
        }
        .disabled(!tappable)
    }

    // MARK: - 4. Actions Row

    private var actionsRow: some View {
        HStack(spacing: 10) {
            actionButton(
                icon: vm.isFavorite ? "star.fill" : "star",
                activeColor: vm.isFavorite ? RingsideTheme.gold : nil
            ) {
                withAnimation(.bouncy) { vm.isFavorite.toggle() }
            }
            .sensoryFeedback(.impact(weight: .medium), trigger: vm.isFavorite)

            actionButton(icon: "square.and.arrow.up", activeColor: nil) { }

            Button {
                withAnimation(.bouncy) { vm.isAddedToLog.toggle() }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: vm.isAddedToLog ? "checkmark" : "plus")
                        .font(.system(.caption, weight: .semibold))
                    Text(vm.isAddedToLog ? "IN LOG" : "ADD TO LOG")
                        .font(.system(.caption, weight: .bold).width(.compressed))
                }
                .foregroundStyle(vm.isAddedToLog ? .black : .white.opacity(0.6))
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(vm.isAddedToLog ? RingsideTheme.gold : Color.white.opacity(0.05))
                .clipShape(.rect(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(
                            vm.isAddedToLog ? Color.clear : Color.white.opacity(0.06),
                            lineWidth: 0.5
                        )
                )
            }
            .sensoryFeedback(.impact(weight: .light), trigger: vm.isAddedToLog)
        }
    }

    private func actionButton(icon: String, activeColor: Color?, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(activeColor ?? .white.opacity(0.5))
                .frame(width: 44, height: 44)
                .background(Color.white.opacity(0.05))
                .clipShape(.rect(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .strokeBorder(
                            activeColor != nil ? activeColor!.opacity(0.3) : Color.white.opacity(0.06),
                            lineWidth: 0.5
                        )
                )
        }
    }

    // MARK: - 5. Discussion Carousel

    private var discussionCarousel: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                sectionLabel(
                    icon: vm.phase == .pre ? "megaphone.fill" : "bubble.left.and.bubble.right.fill",
                    title: vm.carouselLabel
                )
                Spacer()
                Button {
                    vm.showDiscussionModal = true
                } label: {
                    HStack(spacing: 4) {
                        Text("View All")
                            .font(.system(.caption2, weight: .semibold))
                        Image(systemName: "chevron.right")
                            .font(.system(size: 8, weight: .bold))
                    }
                    .foregroundStyle(RingsideTheme.gold.opacity(0.6))
                }
            }
            .padding(.bottom, 12)

            if !vm.carouselComments.isEmpty {
                TabView(selection: $vm.carouselIndex) {
                    ForEach(Array(vm.carouselComments.enumerated()), id: \.element.id) { index, comment in
                        carouselCard(comment)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .automatic))
                .frame(height: 120)
                .onAppear { startCarouselTimer() }
                .gesture(
                    DragGesture(minimumDistance: 5)
                        .onChanged { _ in vm.carouselPaused = true }
                        .onEnded { _ in
                            Task {
                                try? await Task.sleep(for: .seconds(4))
                                vm.carouselPaused = false
                            }
                        }
                )
            } else {
                HStack {
                    Spacer()
                    VStack(spacing: 6) {
                        Image(systemName: "bubble.left.and.text.bubble.right")
                            .font(.title3)
                            .foregroundStyle(.white.opacity(0.15))
                        Text("No comments yet")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.2))
                    }
                    .padding(.vertical, 24)
                    Spacer()
                }
            }
        }
    }

    private func carouselCard(_ comment: DiscussionComment) -> some View {
        Button {
            vm.showDiscussionModal = true
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(RingsideTheme.gold.opacity(0.2))
                        .frame(width: 24, height: 24)
                        .overlay {
                            Text(String(comment.userName.prefix(1)))
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(RingsideTheme.gold)
                        }
                    Text(comment.userName)
                        .font(.system(.caption, weight: .bold))
                        .foregroundStyle(RingsideTheme.gold)
                    if comment.isPrediction {
                        Text("PREDICTION")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(RingsideTheme.gold.opacity(0.8))
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(RingsideTheme.gold.opacity(0.12))
                            .clipShape(Capsule())
                    }
                    Spacer()
                    Text(comment.timestamp, format: .dateTime.hour().minute())
                        .font(.system(size: 9))
                        .foregroundStyle(.white.opacity(0.2))
                }

                Text(comment.text)
                    .font(.system(.subheadline, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 14) {
                    Label("\(comment.thumbsUp)", systemImage: "hand.thumbsup")
                    Label("\(comment.thumbsDown)", systemImage: "hand.thumbsdown")
                    Label("Reply", systemImage: "arrowshape.turn.up.left")
                }
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.white.opacity(0.25))
            }
            .padding(14)
            .background(.ultraThinMaterial)
            .clipShape(.rect(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.06), lineWidth: 0.5)
            )
        }
    }

    private func startCarouselTimer() {
        Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(3))
                guard !vm.carouselPaused, !vm.carouselComments.isEmpty else { continue }
                withAnimation(.easeInOut(duration: 0.4)) {
                    vm.carouselIndex = (vm.carouselIndex + 1) % vm.carouselComments.count
                }
            }
        }
    }

    // MARK: - Section Label Helper

    private func sectionLabel(icon: String, title: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(RingsideTheme.gold.opacity(0.7))
            Text(title)
                .font(.system(.caption, weight: .heavy).width(.compressed))
                .foregroundStyle(.white.opacity(0.4))
        }
    }

    // MARK: - Round Rating Sheet

    private var roundRatingSheet: some View {
        VStack(spacing: 24) {
            VStack(spacing: 4) {
                Text("ROUND \(vm.activeRoundForRating)")
                    .font(.system(.title2, weight: .black).width(.compressed))
                    .foregroundStyle(.primary)
                Text("Score this round")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 8) {
                Text(String(format: "%.1f", vm.roundRatingDraft))
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .foregroundStyle(RingsideTheme.gold)
                    .contentTransition(.numericText())

                Slider(value: $vm.roundRatingDraft, in: 0...10, step: 0.5)
                    .tint(RingsideTheme.gold)
            }

            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(RoundTag.allCases, id: \.rawValue) { tag in
                        Button {
                            withAnimation(.snappy) {
                                if vm.roundTagsDraft.contains(tag) {
                                    vm.roundTagsDraft.remove(tag)
                                } else {
                                    vm.roundTagsDraft.insert(tag)
                                }
                            }
                        } label: {
                            Text(tag.rawValue)
                                .font(.system(.caption, weight: .bold))
                                .foregroundStyle(vm.roundTagsDraft.contains(tag) ? .black : .secondary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    vm.roundTagsDraft.contains(tag)
                                        ? RingsideTheme.gold
                                        : Color(.tertiarySystemFill)
                                )
                                .clipShape(Capsule())
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)

            Button {
                vm.saveRoundRating()
            } label: {
                Text("Save Round Score")
                    .font(.system(.body, weight: .bold))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(RingsideTheme.gold)
                    .clipShape(.rect(cornerRadius: 14))
            }
        }
        .padding(24)
    }

    // MARK: - Prediction Sheet

    private var predictionSheet: some View {
        VStack(spacing: 24) {
            VStack(spacing: 4) {
                Text("YOUR PREDICTION")
                    .font(.system(.title2, weight: .black).width(.compressed))
                    .foregroundStyle(.primary)
                Text("Who wins and how?")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Winner")
                    .font(.system(.caption, weight: .bold))
                    .foregroundStyle(.secondary)
                Picker("Winner", selection: $vm.predictionWinnerDraft) {
                    Text(fight.fighterA.name).tag(fight.fighterA.name)
                    Text(fight.fighterB.name).tag(fight.fighterB.name)
                }
                .pickerStyle(.segmented)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Method")
                    .font(.system(.caption, weight: .bold))
                    .foregroundStyle(.secondary)
                Picker("Method", selection: $vm.predictionMethodDraft) {
                    ForEach(PredictionMethod.allCases, id: \.rawValue) { method in
                        Text(method.rawValue).tag(method)
                    }
                }
                .pickerStyle(.segmented)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Round Range")
                    .font(.system(.caption, weight: .bold))
                    .foregroundStyle(.secondary)
                Picker("Rounds", selection: $vm.predictionRoundDraft) {
                    Text("1–3").tag("1-3")
                    Text("4–6").tag("4-6")
                    Text("7–9").tag("7-9")
                    Text("10–12").tag("10-12")
                }
                .pickerStyle(.segmented)
            }

            Button {
                vm.submitPrediction()
            } label: {
                Text("Lock In Prediction")
                    .font(.system(.body, weight: .bold))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(RingsideTheme.gold)
                    .clipShape(.rect(cornerRadius: 14))
            }
        }
        .padding(24)
    }

    // MARK: - 6. Discussion Modal

    private var discussionModal: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    TextField("Share your take...", text: $vm.newCommentText)
                        .font(.subheadline)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color(.tertiarySystemFill))
                        .clipShape(Capsule())

                    Button {
                        vm.addComment()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundStyle(vm.newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.secondary : RingsideTheme.gold)
                    }
                    .disabled(vm.newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)

                Picker("Sort", selection: $vm.discussionTab) {
                    ForEach(DiscussionTab.allCases, id: \.rawValue) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)

                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(vm.visibleDiscussion) { comment in
                            discussionCommentRow(comment)
                            Divider()
                                .overlay(Color.white.opacity(0.04))
                        }

                        if vm.canLoadMore {
                            Button {
                                vm.loadMoreComments()
                            } label: {
                                Text("Load more comments")
                                    .font(.system(.subheadline, weight: .semibold))
                                    .foregroundStyle(RingsideTheme.gold)
                                    .padding(.vertical, 16)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Match Discussion")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        vm.showDiscussionModal = false
                    }
                    .foregroundStyle(RingsideTheme.gold)
                }
            }
        }
    }

    private func discussionCommentRow(_ comment: DiscussionComment) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Circle()
                    .fill(RingsideTheme.gold.opacity(0.15))
                    .frame(width: 28, height: 28)
                    .overlay {
                        Text(String(comment.userName.prefix(1)))
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(RingsideTheme.gold)
                    }
                VStack(alignment: .leading, spacing: 1) {
                    HStack(spacing: 6) {
                        Text(comment.userName)
                            .font(.system(.subheadline, weight: .bold))
                            .foregroundStyle(.primary)
                        if comment.isPrediction {
                            Text("PREDICTION")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(RingsideTheme.gold)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(RingsideTheme.gold.opacity(0.15))
                                .clipShape(Capsule())
                        }
                    }
                    Text(comment.timestamp, format: .dateTime.hour().minute())
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            Text(comment.text)
                .font(.subheadline)
                .foregroundStyle(.primary.opacity(0.9))

            HStack(spacing: 20) {
                Button {
                    vm.toggleDiscussionThumbsUp(comment.id)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: comment.hasThumbedUp ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .font(.caption)
                        Text("\(comment.thumbsUp)")
                            .font(.caption)
                    }
                    .foregroundStyle(comment.hasThumbedUp ? RingsideTheme.gold : .secondary)
                }

                Button {
                    vm.toggleDiscussionThumbsDown(comment.id)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: comment.hasThumbedDown ? "hand.thumbsdown.fill" : "hand.thumbsdown")
                            .font(.caption)
                        Text("\(comment.thumbsDown)")
                            .font(.caption)
                    }
                    .foregroundStyle(comment.hasThumbedDown ? RingsideTheme.liveRed : .secondary)
                }

                Button { } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "arrowshape.turn.up.left")
                            .font(.caption)
                        Text("Reply")
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Helpers

    private var eventNameForFight: String {
        for event in SampleData.events {
            if event.fights.contains(where: { $0.id == fight.id }) {
                return event.name
            }
        }
        return "RINGSIDE EVENT"
    }

    private var eventSubtitle: String {
        for event in SampleData.events {
            if event.fights.contains(where: { $0.id == fight.id }) {
                return event.venue
            }
        }
        return ""
    }
}

extension Fight {
    var date: Date? {
        for event in SampleData.events {
            if event.fights.contains(where: { $0.id == self.id }) {
                return event.date
            }
        }
        return nil
    }
}
