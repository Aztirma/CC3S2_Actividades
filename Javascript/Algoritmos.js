function firstNonDuplicateChar(str) {
    const charFrequency = {};
    const repeatedChars = new Set();
  
    for (let char of str) {
      if (!charFrequency[char]) {
        charFrequency[char] = 1;
      } else {
        charFrequency[char]++;
        repeatedChars.add(char);
      }
    }
  
    for (let char of str) {
      if (!repeatedChars.has(char)) {
        return `El primer carácter no duplicado es: ${char}`;
      }
    }
  
    return "No hay caracteres no duplicados";
  }
  
  // Ejemplo de uso
  const exampleString = "minimum";
  const result = firstNonDuplicateChar(exampleString);
  
  console.log(result); 
  