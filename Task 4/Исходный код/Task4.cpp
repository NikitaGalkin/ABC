﻿#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <omp.h>

using namespace std;

/// <summary>
/// Проверяет строку, можно ли ее превратить в число.
/// </summary>
/// <param name="line"> Строка. </param>
/// <returns> да / нет. </returns>
static bool CheckOnDigit(string line) {
	return count_if(line.begin(), line.end(), [](char a) {return a >= '0' && a <= '9'; }) == line.size();
}

/// <summary>
/// Принимает от пользователя положительное целое число.
/// </summary>
/// <returns> Число. </returns>
static int GetN(string message) {
	string line;
	int number;
	bool state = false;

	do {
		cout << message;

		getline(cin, line);
		cout << endl;

		// Проверка на то, что число.
		if (!CheckOnDigit(line))
			cout << "Wrong input. Try again." << endl;
		else {
			number = stoi(line);

			// Проверка на то, что число положительное.
			if (number > 0)
				state = true;
			else cout << "Wrong input. Try again." << endl;
		}
	} while (!state);

	return number;
}

/// <summary>
/// Проверяет, можно ли разделить строку на числа (через пробел).
/// </summary>
/// <param name="line"> Строка. </param>
/// <param name="elems"> Числа. </param>
/// <returns> Есть ошибка в строке (есть не число) или нет. </returns>
static bool GetSplittedElements(string line, vector<int>& elems) {
	string number = "";
	// Чистим вектор перед работой.
	elems.clear();

	for (char element : line) {
		// Разделителем является пробел.
		if (element != ' ') {
			// Проверка на то, что элемент строки - цифра.
			if (isdigit(element))
				number += element;
			else {
				cout << "Wrong input! Try again.\n" << endl;
				return false;
			}
		}
		else {
			// Если попадается пробел, переносим собравшееся из цифр число в вектор.
			elems.push_back(stoi(number));
			number = "";
		}
	}

	// Записываем последнее число (если не было в конце разделителя).
	if (number != "")
		elems.push_back(stoi(number));

	return true;
}

/// <summary>
/// Принимает от пользователя матрицу размером n x n.
/// </summary>
/// <param name="n"> Размерность матрицы. </param>
/// <returns> Матрица. </returns>
static vector<vector<int>> SetMatrix(int n) {
	vector<vector<int>> matrix;
	string line;
	bool state;
	vector<int> elems;

	cout << "Now you need to enter the matrix " << n << "*" << n << " by its lines.\n" << endl;

	for (int i = 0; i < n; ++i) {
		state = false;

		do {
			cout << "Enter " << i << " line: ";
			getline(cin, line);
			cout << endl;

			// Проверка на то, что цифры.
			if (GetSplittedElements(line, elems)) {
				// Проверка на длину.
				if (elems.size() == n)
					state = true;
				else cout << "Wrong length! Try again.\n" << endl;
			}
		} while (!state);

		matrix.push_back(elems);

		elems.clear();
	}

	return matrix;
}

/// <summary>
/// Выводит матрицу в консоль.
/// </summary>
/// <param name="matrix"> Матрица. </param>
/// <param name="n"> Размерность матрицы. </param>
static void DisplayMatrix(vector<vector<int>>& matrix, int n) {
	cout << "Your matrix:" << endl;
	for (int i = 0; i < n; ++i) {
		for (int j = 0; j < n; ++j) {
			cout << matrix[i][j] << "\t";
		}
		cout << endl;
	}
}

/// <summary>
/// Проверяет матрицу на наличие ненулевых элементов.
/// </summary>
/// <param name="matrix"> Матрица. </param>
/// <param name="n"> Размерность матрицы. </param>
/// <returns> Есть ненулевые элементы или нет. </returns>
static bool CheckOnZeroElems(const vector<vector<int>>& matrix, int n) {
	for (int i = 0; i < n; ++i) {
		for (int j = 0; j < n; ++j) {
			if (matrix[i][j] != 0)
				return true;
		}
	}

	return false;
}

/// <summary>
/// Находит определитель матрицы размером 2 на 2.
/// </summary>
/// <param name="matrix"> Матрица. </param>
/// <returns> Определитель. </returns>
static int detOfTwo(vector<vector<int>>& matrix)
{
	return matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0];
}

/// <summary>
/// Создает матрицу размером n на n.
/// </summary>
/// <param name="n"> Размерность матрицы. </param>
/// <returns> Матрица. </returns>
static vector<vector<int>> CreateMatrix(int n) {
	vector<vector<int>> newMatrix;
	vector<int> row;

	// Заполняем новую матрицу.
	for (int i = 0; i < n; ++i) {
		row.clear();

		for (int j = 0; j < n; ++j)
			row.push_back(0);

		newMatrix.push_back(row);
	}

	return newMatrix;
}

/// <summary>
/// Находит определитель матрицы.
/// </summary>
/// <param name="matrix"> Матрица. </param>
/// <param name="n"> Размерность матрицы. </param>
/// <returns> Определитель. </returns>
static int Determinant(vector<vector<int>>& matrix, int n)
{
	// Определитель.
	int det = 0;

	// Если длина стороны матрицы 2, то можно найти определитель.
	if (n == 2)
	{
		det += detOfTwo(matrix);
	}
	// Иначе рекурсия продолжается.
	else
	{
		// Новая меньшая матрица, определитель которой нужно найти.
		vector<vector<int>> newMatrix = CreateMatrix(n - 1);

		// Перебор всех миноров (раскладываю по правому столбцу).
		for (int i = 0; i < n; ++i) {
			// Образование минора.
			for (int k = 0; k < n; ++k) {
				for (int j = 0; j < n - 1; ++j) {
					if (k < i)
						newMatrix[k, j] = matrix[k, j];
					else if (k > i)
						newMatrix[k - 1, j] = matrix[k, j];
				}
			}

			// Увеличение / уменьшение определителя в зависимости от знака (чередуется).
			if ((i + n - 1) % 2 == 0)
				det += matrix[i][n - 1] * Determinant(newMatrix, n - 1);
			else
				det -= matrix[i][n - 1] * Determinant(newMatrix, n - 1);
		}
	}

	return det;
}

/// <summary>
/// Проверяет матрицу на наличие ненулевых миноров (определенного размера).
/// </summary>
/// <param name="matrix"> Матрица. </param>
/// <param name="rank"> Проверяемый ранг (размер минора). </param>
/// <param name="n"> Размерность матрицы. </param>
/// <returns> Есть ненулевые миноры или нет. </returns>
static bool CheckMinors(const vector<vector<int>>& matrix, int rank, int n) {
	vector<vector<int>> minor = CreateMatrix(rank);

	// Перебрираем все миноры и находим их определитель.
	for (int i = 0; i <= (n - rank); ++i) {
		for (int j = 0; j <= (n - rank); ++j) {
			// Собираем минор в векторе.
			for (int p = i; p < (i + rank); ++p) {
				for (int k = j; k < (j + rank); ++k) {
					minor[p - i][k - j] = matrix[p][k];
				}
			}
			// Если минор ненулевой.
			if (Determinant(minor, rank) != 0)
				return true;
		}
	}

	return false;
}

/// <summary>
/// Находит число, факториал которого равен передаваемому параметру.
/// </summary>
/// <param name="fact"> Факториал числа. </param>
/// <returns> Число. </returns>
static int FromFactorial(int fact) {
	int sumRes = 0;
	
	for (int i = 1; i < fact; ++i) {
		sumRes += i;

		if (sumRes == fact) return i;
	}

	return 1;
}

/// <summary>
/// Находит ранг матрицы.
/// </summary>
/// <param name="matrix"> Матрица. </param>
/// <param name="n"> Размерность матрицы. </param>
/// <returns> Ранг. </returns>
static int FindRank(const vector<vector<int>>& matrix, int n) {
	int sumRank = 0;

	#pragma omp parallel reduction (+: sumRank)
	{
		#pragma omp for
		// Проходимся для каждого ранга.
		for (int currentRank = 1; currentRank <= n; ++currentRank) {
			cout << "thread >> " << omp_get_thread_num() << endl;
			switch (currentRank) {
			case 1:
				// Проверка на ранг = 1.
				if (CheckOnZeroElems(matrix, n))
					sumRank = 1;
				else {
					sumRank = 0;
					break;
				}
				break;
			default:
				// Проверка на все другие ранги.
				if (CheckMinors(matrix, currentRank, n))
					sumRank = currentRank;
				else break;
			}
		}
	}

	if (sumRank != 0)
		return FromFactorial(sumRank);
	else return 0;
}

int main()
{
	// Принимаем размерность матрицы.
	int n = GetN("Input size of matrix >> ");
	// Создаем матрицу и принимаем ее значения.
	vector<vector<int>> matrix = SetMatrix(n);

	// Выводим получившуюся матрицу.
	DisplayMatrix(matrix, n);

	cout << endl;

	// Находим ранг этой матрицы.
	int rank = FindRank(matrix, n);

	cout << endl;

	// Выводим результат.
	cout << "Rank: " << rank << endl;
}