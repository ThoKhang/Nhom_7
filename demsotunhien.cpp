#include <stdio.h>
int dem (int a)
{
	int s,b;
	s=0;
	while(a!=0)
	{
		s=s+1;
		a=a/10;
	}
	return s;
}
main()
{
	int n;
	printf("vui long nhap gia tri cua n: ");
	scanf("%d",&n);
	printf("so %d co %d chu so",n,dem(n));
}
