package com.qaantum.calculatorhub.calculators

import java.util.Stack
import kotlin.math.*

class ScientificCalculator {
    private var input: String = "0"
    private var result: String = ""

    fun getInput(): String = input
    fun getResult(): String = result

    fun onButtonPressed(buttonText: String) {
        when (buttonText) {
            "C" -> {
                input = "0"
                result = ""
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
                if (input == "0" && !isOperator(buttonText) && !isFunction(buttonText)) {
                    input = buttonText
                } else {
                    input += buttonText
                }
            }
        }
    }

    private fun isOperator(x: String): Boolean {
        return x in listOf("+", "-", "*", "/", "^", "(", ")")
    }

    private fun isFunction(x: String): Boolean {
        return x in listOf("sin", "cos", "tan", "ln", "log", "sqrt", "π", "e")
    }

    private fun calculate() {
        try {
            var finalInput = input
            finalInput = finalInput.replace("×", "*")
            finalInput = finalInput.replace("÷", "/")
            finalInput = finalInput.replace("π", "${PI}")
            finalInput = finalInput.replace("e", "${E}")

            // Handle functions before parsing
            finalInput = replaceFunctions(finalInput)

            val result = evaluateExpression(finalInput)
            
            // Remove decimal if integer
            if (result % 1 == 0.0) {
                this.result = result.toInt().toString()
                input = this.result
            } else {
                this.result = String.format("%.10f", result).trimEnd('0').trimEnd('.')
                input = this.result
            }
        } catch (e: Exception) {
            result = "Error"
        }
    }

    private fun replaceFunctions(expression: String): String {
        var result = expression
        
        // Replace function calls with their values
        val functions = mapOf(
            "sin" to "sin",
            "cos" to "cos",
            "tan" to "tan",
            "ln" to "ln",
            "log" to "log10",
            "sqrt" to "sqrt"
        )
        
        // Simple function replacement (this is a simplified version)
        // In a full implementation, you'd parse the expression tree properly
        functions.forEach { (func, _) ->
            val regex = "$func\\(([^)]+)\\)".toRegex()
            result = regex.replace(result) { matchResult ->
                val arg = matchResult.groupValues[1].toDoubleOrNull() ?: return@replace matchResult.value
                val value = when (func) {
                    "sin" -> sin(Math.toRadians(arg))
                    "cos" -> cos(Math.toRadians(arg))
                    "tan" -> tan(Math.toRadians(arg))
                    "ln" -> ln(arg)
                    "log" -> log10(arg)
                    "sqrt" -> sqrt(arg)
                    else -> arg
                }
                value.toString()
            }
        }
        
        return result
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
                expression[i] in "+-*/^" -> {
                    tokens.add(expression[i].toString())
                }
                expression[i] == '(' -> tokens.add("(")
                expression[i] == ')' -> tokens.add(")")
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
            "^" -> 3
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
                token == "^" -> {
                    val b = stack.pop()
                    val a = stack.pop()
                    stack.push(a.pow(b))
                }
            }
        }
        
        return stack.pop()
    }
}

