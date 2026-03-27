//
//  CategoryDetailSheet.swift
//  WalletWars
//

import SwiftUI
import SwiftData
import Charts

struct CategoryDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let category: Category
    @State private var budgetText: String = ""
    @State private var dailySpending: [DailySpend] = []
    @State private var weekTotal: Double = 0
    @State private var monthTotal: Double = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    categoryHeader
                    spendingChart
                    statsRow
                    budgetSection
                }
                .padding(20)
            }
            .background(Color.surface)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .font(.custom("PlusJakartaSans-Bold", size: 14))
                        .foregroundStyle(Color.hero)
                }
            }
            .task { loadData() }
        }
    }
}

// MARK: - Header

private extension CategoryDetailSheet {
    var categoryHeader: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(catColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: category.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(catColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(category.name)
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 20))
                    .foregroundStyle(Color.textPrimary)
                Text("Last 7 days")
                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                    .foregroundStyle(Color.textLight)
            }

            Spacer()
        }
    }

    var catColor: Color {
        Color(hex: category.colorHex)
    }
}

// MARK: - Chart

private extension CategoryDetailSheet {
    var spendingChart: some View {
        Chart(dailySpending) { day in
            BarMark(
                x: .value("Day", day.label),
                y: .value("Amount", day.amount)
            )
            .foregroundStyle(catColor.gradient)
            .cornerRadius(4)
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisValueLabel {
                    if let v = value.as(Double.self) {
                        Text("$\(Int(v))")
                            .font(.custom("PlusJakartaSans-Regular", size: 10))
                            .foregroundStyle(Color.textLight)
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let label = value.as(String.self) {
                        Text(label)
                            .font(.custom("PlusJakartaSans-Bold", size: 10))
                            .foregroundStyle(Color.textMid)
                    }
                }
            }
        }
        .frame(height: 160)
        .padding(12)
        .background(Color.card, in: RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.textLight.opacity(0.1), lineWidth: 1)
        }
    }
}

// MARK: - Stats

private extension CategoryDetailSheet {
    var statsRow: some View {
        HStack(spacing: 12) {
            statPill(label: "THIS WEEK", amount: weekTotal)
            statPill(label: "THIS MONTH", amount: monthTotal)
        }
    }

    func statPill(label: String, amount: Double) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.custom("PlusJakartaSans-Bold", size: 9))
                .tracking(1)
                .foregroundStyle(Color.textLight)
            Text("$\(amount, specifier: "%.0f")")
                .font(.custom("PlusJakartaSans-ExtraBold", size: 20))
                .foregroundStyle(catColor)
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .background(Color.card, in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.textLight.opacity(0.1), lineWidth: 1)
        }
    }
}

// MARK: - Budget

private extension CategoryDetailSheet {
    var budgetSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("MONTHLY BUDGET")
                .font(.custom("PlusJakartaSans-Bold", size: 10))
                .tracking(1.5)
                .foregroundStyle(Color.textLight)

            HStack(spacing: 8) {
                Text("$")
                    .font(.custom("PlusJakartaSans-Bold", size: 20))
                    .foregroundStyle(Color.textMid)

                TextField("Not set", text: $budgetText)
                    .font(.custom("PlusJakartaSans-ExtraBold", size: 24))
                    .foregroundStyle(Color.victory)
                    .keyboardType(.decimalPad)

                Spacer()

                Button {
                    saveBudget()
                } label: {
                    Text("Save")
                        .font(.custom("PlusJakartaSans-Bold", size: 13))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.victory, in: Capsule())
                }
            }
            .padding(14)
            .background(Color.card, in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(Color.textLight.opacity(0.1), lineWidth: 1)
            }

            if let budget = category.budgetAmount, budget > 0 {
                budgetProgress(budget: budget)
            }
        }
    }

    func budgetProgress(budget: Double) -> some View {
        VStack(spacing: 6) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.surfaceHigh)
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(progressColor(budget: budget))
                        .frame(width: max(0, geo.size.width * min(monthTotal / budget, 1.0)), height: 6)
                }
            }
            .frame(height: 6)

            HStack {
                Text("\(Int(monthTotal / budget * 100))% used")
                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                    .foregroundStyle(progressColor(budget: budget))
                Spacer()
                Text("$\(Int(budget - monthTotal)) remaining")
                    .font(.custom("PlusJakartaSans-Regular", size: 12))
                    .foregroundStyle(Color.textLight)
            }
        }
    }

    func progressColor(budget: Double) -> Color {
        let pct = monthTotal / budget
        switch pct {
        case ..<0.5:   return .victory
        case 0.5..<0.8: return .streak
        default:        return .rival
        }
    }
}

// MARK: - Data

private extension CategoryDetailSheet {
    struct DailySpend: Identifiable {
        let id = UUID()
        let label: String
        let amount: Double
    }

    func loadData() {
        budgetText = category.budgetAmount.map { String(format: "%.0f", $0) } ?? ""

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)

        // Last 7 days of spending
        var daily: [DailySpend] = []
        let categoryID = category.id

        for i in (0..<7).reversed() {
            let date = calendar.date(byAdding: .day, value: -i, to: today)!
            let nextDate = calendar.date(byAdding: .day, value: 1, to: date)!

            let descriptor = FetchDescriptor<Transaction>(
                predicate: #Predicate<Transaction> { tx in
                    tx.date >= date && tx.date < nextDate
                }
            )
            let transactions = (try? modelContext.fetch(descriptor)) ?? []
            let catSpend = transactions.filter { $0.category?.id == categoryID }.reduce(0) { $0 + $1.amount }

            let dayName = i == 0 ? "Today" : date.formatted(.dateTime.weekday(.abbreviated))
            daily.append(DailySpend(label: dayName, amount: catSpend))
        }
        dailySpending = daily

        // Week total
        weekTotal = daily.reduce(0) { $0 + $1.amount }

        // Month total
        let monthComponents = calendar.dateComponents([.year, .month], from: today)
        let monthStart = calendar.date(from: monthComponents)!
        let monthEnd = calendar.date(byAdding: .month, value: 1, to: monthStart)!
        let monthDescriptor = FetchDescriptor<Transaction>(
            predicate: #Predicate<Transaction> { tx in
                tx.date >= monthStart && tx.date < monthEnd
            }
        )
        let monthTx = (try? modelContext.fetch(monthDescriptor)) ?? []
        monthTotal = monthTx.filter { $0.category?.id == categoryID }.reduce(0) { $0 + $1.amount }
    }

    func saveBudget() {
        if let value = Double(budgetText), value > 0 {
            category.budgetAmount = value
        } else {
            category.budgetAmount = nil
        }
        try? modelContext.save()
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
