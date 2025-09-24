"use client";

import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Checkbox } from "@/components/ui/checkbox";
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
  CardDescription,
  CardFooter,
} from "@/components/ui/card";
import { useState, useEffect } from "react";
import { CircleAlert, Eye, EyeOff, Lock, Mail, User, AtSign, Globe } from "lucide-react";
import Link from "next/link";
import { useAuth } from "@/hooks/auth";
import InputError from "@/components/ui/InputError";

const countries = [
  "United States", "Canada", "United Kingdom", "Australia", "Germany", "France", "Japan", "China",
  "Brazil", "India", "South Korea", "Italy", "Spain", "Netherlands", "Sweden", "Norway",
  "Philippines", "Singapore", "Malaysia", "Thailand", "Indonesia", "Vietnam", "Other"
];

const hobbies = [
  "Reading", "Gaming", "Sports", "Music", "Cooking", "Travel", "Photography", "Art",
  "Writing", "Movies", "Dancing", "Hiking", "Swimming", "Cycling", "Gardening", "Coding"
];

export function SignUpForm() {
  const { register } = useAuth({
    middleware: "guest",
    redirectIfAuthenticated: "/dashboard",
  });
  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [formData, setFormData] = useState({
    name: "",
    username: "",
    email: "",
    password: "",
    confirmPassword: "",
    gender: "",
    hobbies: [] as string[],
    country: "",
  });
  const [errors, setErrors] = useState<Record<string, string[]>>({});
  const [clientErrors, setClientErrors] = useState<Record<string, string>>({});

  // Client-side validation
  const validateForm = () => {
    const newErrors: Record<string, string> = {};

    if (!formData.name.trim()) newErrors.name = "Full name is required";
    if (!formData.username.trim()) newErrors.username = "Username is required";
    if (!formData.email.trim()) newErrors.email = "Email is required";
    else if (!/\S+@\S+\.\S+/.test(formData.email)) newErrors.email = "Email format is invalid";
    if (!formData.password) newErrors.password = "Password is required";
    else if (formData.password.length < 8) newErrors.password = "Password must be at least 8 characters";
    if (!formData.confirmPassword) newErrors.confirmPassword = "Please confirm password";
    else if (formData.password !== formData.confirmPassword) newErrors.confirmPassword = "Passwords do not match";
    if (!formData.gender) newErrors.gender = "Gender is required";
    if (formData.hobbies.length === 0) newErrors.hobbies = "Please select at least one hobby";
    if (!formData.country) newErrors.country = "Country is required";

    setClientErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  // Real-time validation
  useEffect(() => {
    if (Object.keys(clientErrors).length > 0) {
      const timer = setTimeout(() => {
        validateForm();
      }, 500);
      return () => clearTimeout(timer);
    }
  }, [formData]);

  // Handle input changes
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  const handleGenderChange = (value: string) => {
    setFormData((prev) => ({
      ...prev,
      gender: value,
    }));
  };

  const handleHobbyChange = (hobby: string, checked: boolean) => {
    setFormData((prev) => ({
      ...prev,
      hobbies: checked
        ? [...prev.hobbies, hobby]
        : prev.hobbies.filter((h) => h !== hobby),
    }));
  };

  const handleCountryChange = (value: string) => {
    setFormData((prev) => ({
      ...prev,
      country: value,
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!validateForm()) {
      return;
    }

    setLoading(true);
    setErrors({});
    
    await register({
      name: formData.name,
      username: formData.username,
      email: formData.email,
      password: formData.password,
      password_confirmation: formData.confirmPassword,
      gender: formData.gender,
      hobbies: formData.hobbies,
      country: formData.country,
      setErrors,
    });
    setLoading(false);
  };

  const togglePasswordVisibility = () => {
    setShowPassword(!showPassword);
  };

  return (
    <div className="min-h-screen w-full flex items-center justify-center bg-gradient-to-b from-gray-50 to-gray-100 dark:from-gray-900 dark:to-gray-950 p-4">
      <Card className="w-full max-w-2xl shadow-lg border-x-0 border-b-0 border-t-4 border-primary">
        <CardHeader className="space-y-1">
          <div className="flex justify-center mb-2">
            <div className="h-12 w-12 rounded-full bg-primary/10 flex items-center justify-center">
              <User className="h-6 w-6 text-primary" />
            </div>
          </div>
          <CardTitle className="text-center text-2xl font-bold">
            Create an Account
          </CardTitle>
          <CardDescription className="text-center">
            Enter your details to create your account
          </CardDescription>
        </CardHeader>

        <CardContent>
          {errors && Object.keys(errors).length > 0 && (
            <div className="flex items-center gap-2 bg-destructive/10 text-destructive text-sm p-3 rounded-md mb-4">
              <CircleAlert size={16} />
              {errors[Object.keys(errors)[0]][0]}
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Basic Information */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="name" className="text-sm font-medium">
                  Full Name *
                </Label>
                <div className="relative">
                  <User className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                  <Input
                    id="name"
                    name="name"
                    type="text"
                    placeholder="John Doe"
                    className="pl-10"
                    value={formData.name}
                    onChange={handleChange}
                    required
                  />
                </div>
                {clientErrors.name && <InputError messages={[clientErrors.name]} />}
              </div>

              <div className="space-y-2">
                <Label htmlFor="username" className="text-sm font-medium">
                  Username *
                </Label>
                <div className="relative">
                  <AtSign className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                  <Input
                    id="username"
                    name="username"
                    type="text"
                    placeholder="johndoe"
                    className="pl-10"
                    value={formData.username}
                    onChange={handleChange}
                    required
                  />
                </div>
                {clientErrors.username && <InputError messages={[clientErrors.username]} />}
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="email" className="text-sm font-medium">
                Email Address *
              </Label>
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                <Input
                  id="email"
                  name="email"
                  type="email"
                  placeholder="your.email@example.com"
                  className="pl-10"
                  value={formData.email}
                  onChange={handleChange}
                  required
                />
              </div>
              {clientErrors.email && <InputError messages={[clientErrors.email]} />}
            </div>

            {/* Password Fields */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="password" className="text-sm font-medium">
                  Password *
                </Label>
                <div className="relative">
                  <Lock className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                  <Input
                    id="password"
                    name="password"
                    type={showPassword ? "text" : "password"}
                    placeholder="••••••••"
                    className="pl-10"
                    value={formData.password}
                    onChange={handleChange}
                    required
                    minLength={8}
                  />
                  <button
                    type="button"
                    onClick={togglePasswordVisibility}
                    className="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground"
                  >
                    {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                  </button>
                </div>
                {clientErrors.password && <InputError messages={[clientErrors.password]} />}
              </div>

              <div className="space-y-2">
                <Label htmlFor="confirmPassword" className="text-sm font-medium">
                  Confirm Password *
                </Label>
                <div className="relative">
                  <Lock className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                  <Input
                    id="confirmPassword"
                    name="confirmPassword"
                    type={showPassword ? "text" : "password"}
                    placeholder="••••••••"
                    className="pl-10"
                    value={formData.confirmPassword}
                    onChange={handleChange}
                    required
                  />
                </div>
                {clientErrors.confirmPassword && <InputError messages={[clientErrors.confirmPassword]} />}
              </div>
            </div>

            {/* Gender */}
            <div className="space-y-2">
              <Label className="text-sm font-medium">Gender *</Label>
              <RadioGroup value={formData.gender} onValueChange={handleGenderChange} className="flex gap-6">
                <div className="flex items-center space-x-2">
                  <RadioGroupItem value="male" id="male" />
                  <Label htmlFor="male">Male</Label>
                </div>
                <div className="flex items-center space-x-2">
                  <RadioGroupItem value="female" id="female" />
                  <Label htmlFor="female">Female</Label>
                </div>
                <div className="flex items-center space-x-2">
                  <RadioGroupItem value="other" id="other" />
                  <Label htmlFor="other">Other</Label>
                </div>
              </RadioGroup>
              {clientErrors.gender && <InputError messages={[clientErrors.gender]} />}
            </div>

            {/* Hobbies */}
            <div className="space-y-2">
              <Label className="text-sm font-medium">Hobbies * (Select at least one)</Label>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
                {hobbies.map((hobby) => (
                  <div key={hobby} className="flex items-center space-x-2">
                    <Checkbox
                      id={hobby}
                      checked={formData.hobbies.includes(hobby)}
                      onCheckedChange={(checked) => handleHobbyChange(hobby, checked as boolean)}
                    />
                    <Label htmlFor={hobby} className="text-sm">{hobby}</Label>
                  </div>
                ))}
              </div>
              {clientErrors.hobbies && <InputError messages={[clientErrors.hobbies]} />}
            </div>

            {/* Country */}
            <div className="space-y-2">
              <Label className="text-sm font-medium">Country *</Label>
              <Select value={formData.country} onValueChange={handleCountryChange}>
                <SelectTrigger className="w-full">
                  <div className="flex items-center gap-2">
                    <Globe className="h-4 w-4 text-muted-foreground" />
                    <SelectValue placeholder="Select your country" />
                  </div>
                </SelectTrigger>
                <SelectContent>
                  {countries.map((country) => (
                    <SelectItem key={country} value={country}>
                      {country}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
              {clientErrors.country && <InputError messages={[clientErrors.country]} />}
            </div>

            <Button type="submit" className="w-full" disabled={loading}>
              {loading ? "Creating Account..." : "Sign Up"}
            </Button>
          </form>
        </CardContent>

        <CardFooter className="flex justify-center">
          <p className="text-sm text-center text-muted-foreground">
            Already have an account?{" "}
            <Link href="/" className="text-primary hover:underline">
              Sign In
            </Link>
          </p>
        </CardFooter>
      </Card>
    </div>
  );
}
