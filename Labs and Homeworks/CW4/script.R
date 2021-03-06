#Загрузите данные в датафрейм
gmp <- read.table(file = "https://raw.githubusercontent.com/SergeyMirvoda/MD-DA-2017/master/data/gmp.dat")
gmp$pop <- gmp$gmp / gmp$pcgmp

estimate.scaling.exponent <- function(a, y0 = 6611, response = gmp$pcgmp,
                                        predictor = gmp$pop, maximum.iterations = 100, deriv.step = 1 / 100,
                                        step.scale = 1e-12, stopping.deriv = 1 / 100) {
    mse <- function(a) { mean((response - y0 * predictor ^ a) ^ 2) }
    for (iteration in 1:maximum.iterations) {
        deriv <- (mse(a + deriv.step) - mse(a)) / deriv.step
        a <- a - step.scale * deriv
        if (abs(deriv) <= stopping.deriv) { break () }
        }
    fit <- list(a = a, iterations = iteration,
              converged = (iteration < maximum.iterations))
    return(fit)
}
#Пример вызова с начальным занчением a
estimate.scaling.exponent(0.15)

#С помошью полученного коэффициента постройте кривую (функция curve) зависимости
y.init = 6611
curve(y.init * x ^ estimate.scaling.exponent(0.15, y0 = y.init)$a, xlab = "Население", ylab = "ВВП / Человека", from = 1, to = 1000);

#Удалите точку из набора исходных данных случайным образом, как изменилось статистическая оценка коэффициента a?
scaling.exponent.init <- estimate.scaling.exponent(0.15)$a
gmp.length <- nrow(gmp)
random.index <- abs(gmp.length - round(rnorm(1, gmp.length / 2, gmp.length / 4)))
gmp <- gmp[-random.index,]

scaling.exponent.current <- estimate.scaling.exponent(0.15)$a
scaling.exponent.current - scaling.exponent.init
#Запустите оценку несколько раз с разных стартовых точек. Как изменилось значение a?
estimate.scaling.exponent(0)$a - scaling.exponent.init
estimate.scaling.exponent(0.05)$a - scaling.exponent.init
estimate.scaling.exponent(0.10)$a - scaling.exponent.init
estimate.scaling.exponent(0.20)$a - scaling.exponent.init
estimate.scaling.exponent(0.25)$a - scaling.exponent.init
estimate.scaling.exponent(0.30)$a - scaling.exponent.init
estimate.scaling.exponent(0.50)$a - scaling.exponent.init