#include <stdio.h>
int main() {
	int N,a,luu;
	luu=0; 
	scanf("%d",&N);
	printf("~");
	while (N>=0) { 
		a=N%10; 
		printf("%d",a);
		N=N/10; 
		if (N==0) {
		break;}
	} 
	return 0; 
}
