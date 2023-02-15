#include <criterion/criterion.h>

#include "common.h"

Test(commontests, create)
{
    int *p = NULL;
    cr_expect(p == NULL, "Expecting Null.");
}
