package com.qaantum.calculatorhub.calculators

import java.util.Stack

class StandardCalculator {
    private var input: String = "0"
    private var result: String = ""
    private var expression: String = ""

    fun getInput(): String = input
    fun getResult(): String = result
    fun getExpression(): String = expression

    fun onButtonPressed(buttonText: String) {
        when (buttonText) {
            "C" -> {
                input = "0"
                result = ""
                expression = ""
            }
            "⌫" -> {
                if (input.length > 1) {
                    input = input.substring(0, input.length - 1)
                } else {
                    input = "0"
                }
            }
            "=" -> {
                calculate()
            }
            else -> {
                if (input == "0" && !isOperator(buttonText)) {
                    input = buttonText
                } else {
                    input += buttonText
                }
            }
        }
    }

    private fun isOperator(x: String): Boolean {
        return x == "/" || x == "*" || x == "-" || x == "+"
    }

    private fun calculate() {
        try {
            var finalInput = input
            finalInput = finalInput.replace("×", "*")
            finalInput = finalInput.replace("÷", "/")

            val result = evaluateExpression(finalInput)
            expression = input
            
            // Remove decimal if integer
            val doubleResult = result.toDouble()
            if (doubleResult % 1 == 0.0) {
                this.result = doubleResult.toInt().toString()
                input = this.result
            } else {
                this.result = doubleResult.toString()
                input = this.result
            }
        } catch (e: Exception) {
            result = "Error"
        }
    }

    private fun evaluateExpression(expression: String): Double {
        val tokens = tokenize(expression)
        val postfix = infixToPostfix(tokens)
        return evaluatePostfix(postfix)
    }

    private fun tokenize(expression: String): List<String> {
        val tokens = mutableListOf<String>()
        var i = 0
        while (i < expression.length) {
            when {
                expression[i].isDigit() || expression[i] == '.' -> {
                    val sb = StringBuilder()
                    while (i < expression.length && (expression[i].isDigit() || expression[i] == '.')) {
                        sb.append(expression[i])
                        i++
                    }
                    tokens.add(sb.toString())
                    i--
                }
                expression[i] in "+-*/" -> {
                    tokens.add(expression[i].toString())
                }
            }
            i++
        }
        return tokens
    }

    private fun infixToPostfix(tokens: List<String>): List<String> {
        val output = mutableListOf<String>()
        val operators = Stack<String>()
        
        for (token in tokens) {
            when {
                token.matches(Regex("\\d+\\.?\\d*")) -> output.add(token)
                token == "(" -> operators.push(token)
                token == ")" -> {
                    while (operators.isNotEmpty() && operators.peek() != "(") {
                        output.add(operators.pop())
                    }
                    operators.pop()
                }
                else -> {
                    while (operators.isNotEmpty() && precedence(operators.peek()) >= precedence(token)) {
                        output.add(operators.pop())
                    }
                    operators.push(token)
                }
            }
        }
        
        while (operators.isNotEmpty()) {
            output.add(operators.pop())
        }
        
        return output
    }

    private fun precedence(op: String): Int {
        return when (op) {
            "+", "-" -> 1
            "*", "/" -> 2
            else -> 0
        }
    }

    private fun evaluatePostfix(postfix: List<String>): Double {
        val stack = Stack<Double>()
        
        for (token in postfix) {
            when {
                token.matches(Regex("\\d+\\.?\\d*")) -> stack.push(token.toDouble())
                token == "+" -> {
                    val b = stack.pop()
                    val a = stack.pop()
                    stack.push(a + b)
                }
                token == "-" -> {
                    val b = stack.pop()
                    val a = stack.pop()
                    stack.push(a - b)
                }
                token == "*" -> {
                    val b = stack.pop()
                    val a = stack.pop()
                    stack.push(a * b)
                }
                token == "/" -> {
                    val b = stack.pop()
                    val a = stack.pop()
                    stack.push(a / b)
                }
            }
        }
        
        return stack.pop()
    }
}

